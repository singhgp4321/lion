//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "Graphite.h"

template <>
InputParameters
validParams<Graphite>()
{
  InputParameters params = validParams<Material>();

  return params;
}

Graphite::Graphite(const InputParameters & parameters)
  : Material(parameters),

    // Declare material properties.  This returns references that we
    // hold onto as member variables
    _specific_heat(declareProperty<Real>("specific_heat")),
    _thermal_conductivity(declareProperty<Real>("thermal_conductivity")),
    _electrical_conductivity(declareProperty<Real>("electrical_conductivity")),
    _density(declareProperty<Real>("density"))

{
}

void
Graphite::computeQpProperties()
{
  _specific_heat[_qp] = 720.0; // (J/kg-K)
  _thermal_conductivity[_qp] = 104.4; // (W/m-K) from IBIDEN Fine Graphite Material.pdf
  _electrical_conductivity[_qp] = 71428.6;  // (S/m) from IBIDEN Fine Graphite Material.pdf
  _density[_qp] = 1750.0;       // (kg/m^3) IBIDEN Fine Graphite Material.pdf

}

