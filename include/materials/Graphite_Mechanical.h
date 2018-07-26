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

#ifndef GRAPHITE_MECHANICAL_H
#define GRAPHITE_MECHANICAL_H

#include "SolidModel.h"

//Forward Declarations
class Graphite_Mechanical;

template<>
InputParameters validParams<Graphite_Mechanical>();

class Graphite_Mechanical : public SolidModel
{
private:


public:
  Graphite_Mechanical(const InputParameters & parameters);

protected:
  MaterialProperty<Real> & _thermal_strain;
  MaterialProperty<Real> & _thermal_strain_old;

  bool updateElasticityTensor(SymmElasticityTensor & tensor);
  void computeStress();
  void modifyStrainIncrement();
  void computeThermalStrain(Real & thermal_strain_increment);

};
Real Graphite_linear_thermal_strain(Real Temp);
Real Graphite_poissons_ratio();
Real Graphite_shear_modulus(Real YM, Real PR);
Real Graphite_elastic_modulus();

#endif //GRAPHITE_MECHANICAL_H
