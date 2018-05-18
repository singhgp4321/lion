//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef GRAPHITE_H
#define GRAPHITE_H

#include "Material.h"

class Graphite;

template <>
InputParameters validParams<Graphite>();

/**
 * Material objects inherit from Material and override computeQpProperties.
 *
 * Their job is to declare properties for use by other objects in the
 * calculation such as Kernels and BoundaryConditions.
 */
class Graphite : public Material
{
public:
  Graphite(const InputParameters & parameters);

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

#endif // GRAPHITE_H
