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

#ifndef SIC_MECHANICAL_H
#define SIC_MECHANICAL_H

#include "SolidModel.h"

//Forward Declarations
class SiC_Mechanical;

template<>
InputParameters validParams<SiC_Mechanical>();

class SiC_Mechanical : public SolidModel
{
private:


public:
  SiC_Mechanical(const InputParameters & parameters);

protected:
  MaterialProperty<Real> & _thermal_strain;
  MaterialProperty<Real> & _thermal_strain_old;

  bool updateElasticityTensor(SymmElasticityTensor & tensor);
  void computeStress();
  void modifyStrainIncrement();
  void computeThermalStrain(Real & thermal_strain_increment);
};

Real SiC_linear_thermal_strain(Real Temp);
Real SiC_poissons_ratio();
Real SiC_shear_modulus(Real YM, Real PR);
Real SiC_elastic_modulus();

#endif //SIC_MECHANICAL_H
