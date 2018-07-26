/*************************************************/
/*           DO NOT MODIFY THIS HEADER           */
/*                                               */
/*                     BISON                     */
/*                                               */
/*    (c) 2015 Battelle Energy Alliance, LLC     */
/*            ALL RIGHTS RESERVED                */
/*                                               */
/*   Prepared by Battelle Energy Alliance, LLC   */
/*     Under Contract No. DE-AC07-05ID14517      */
/*     With the U. S. Department of Energy       */
/*                                               */
/*     See COPYRIGHT for full restrictions       */
/*************************************************/

#include "SiC_Mechanical.h"
#include "SymmElasticityTensor.h"
#include "SymmIsotropicElasticityTensor.h"

#include <cmath>

template<>
InputParameters validParams<SiC_Mechanical>()
{
   InputParameters params = validParams<SolidModel>();
   return params;
}

SiC_Mechanical::SiC_Mechanical(const InputParameters & parameters)
  : SolidModel(parameters),
  _thermal_strain(declareProperty<Real>("thermal_strain")),
  _thermal_strain_old(declarePropertyOld<Real>("thermal_strain"))

{
}
void
SiC_Mechanical::computeStress()
{
  SymmTensor stress_new( _elasticity_tensor[_qp] * _strain_increment );
  _stress[_qp]  = stress_new;
  _stress[_qp] += _stress_old;

}
void
SiC_Mechanical::modifyStrainIncrement()
{
  // evaluating strain increment due to thermal expansion

  if( _has_temp && _t_step != 0)
    {
    Real thermal_strain_increment(0.0);
    computeThermalStrain(thermal_strain_increment);
    _strain_increment.addDiag( -thermal_strain_increment);
    }
}


void
SiC_Mechanical::computeThermalStrain(Real & thermal_strain_increment)
{
  Real LTE(0.0), LTE0(0.0);
  LTE = SiC_linear_thermal_strain(_temperature[_qp]);
  LTE0 = SiC_linear_thermal_strain(_temperature_old[_qp]);
  thermal_strain_increment = LTE - LTE0;
  _thermal_strain[_qp] = thermal_strain_increment;// prob has error
  _thermal_strain[_qp] += _thermal_strain_old[_qp];
  // if (_current_elem->id()==10)
  // {
  //  std::cout<<"\n thermal strain is "<<_thermal_strain[_qp];
  // }
}


bool
SiC_Mechanical::updateElasticityTensor(SymmElasticityTensor & tensor)
{
  bool changed(false);
  Real YM(0.0);
  Real PR(0.0);
  Real SM(0.0);

  SymmIsotropicElasticityTensor * t = dynamic_cast<SymmIsotropicElasticityTensor*>(&tensor);
  if (!t)
  {
      mooseError("Cannot use Youngs modulus or Poissons ratio functions");
  }
  t->unsetConstants();

  YM = SiC_elastic_modulus();
  //    YM = 204E9*(1-(6*_volumetric_irradiation_strain[_qp]));
  PR = SiC_poissons_ratio();
  SM = SiC_shear_modulus(YM, PR); //should be called after YM and PR are calculated
  // Moose::out << "Young's Modulus" << YM << std::endl;
  // Moose::out << "Poission's Ratio" << PR << std::endl;
  t->constant(false);
  t->setYoungsModulus(YM);
  t->setPoissonsRatio(PR);
  t->setShearModulus(SM);
   // Moose::out << " t= " << *t  << std::endl;
  changed = true;
  return changed;

}

///////////////////////////////////////////////////////////////////////
//
//     Coefficient of thermal expansion obtained from Katoh et al, J of
//     Nuclear Materials, 448, 2014 (equation 5 in the paper).
//
///////////////////////////////////////////////////////////////////////

Real SiC_linear_thermal_strain(Real Temp)
{
  Real LTE2(0.0);
  Real CTE(0.0);
  CTE = 1e-6;
//  CTE = (-0.7765 + 1.4350E-2*Temp - 1.2209E-5*pow(Temp,2) + 3.8289E-9*pow(Temp,3))*1E-6;
  LTE2 = CTE*(Temp-273.15);
  return LTE2;
}



Real SiC_elastic_modulus()
{

  Real YM(0.0);
  YM = 100E4;
  return YM; // Pa

}

Real SiC_shear_modulus(Real youngs_modulus, Real poissons_ratio)
{

  Real SM(0.0);
  SM = youngs_modulus/(2*(1+poissons_ratio));
  return SM;
}

Real SiC_poissons_ratio()
{
  Real PR(0.0);
  PR = 0.20;
  return PR;
}
