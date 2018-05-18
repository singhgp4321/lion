//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef SIC_H
#define SIC_H

#include "Material.h"

class SiC;

template <>
InputParameters validParams<SiC>();

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class SiC : public Material
{
public:
  SiC(const InputParameters & parameters);

protected:
  /**
   * Necessary override.  This is where the values of the properties
   * are computed.
   */
  virtual void computeQpProperties() override;


  /// The specific heat capacity (J/kg-K)
  MaterialProperty<Real> & _specific_heat;

  /// The thermal conductivity (W/m-K)
  MaterialProperty<Real> & _thermal_conductivity;

  /// The electrical conductivity (S/m) or (siemens/m)
  MaterialProperty<Real> & _electrical_conductivity;

  /// The density (kg/m^3)
  MaterialProperty<Real> & _density;
};

#endif // SIC_H
