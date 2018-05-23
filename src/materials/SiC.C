//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "SiC.h"

template <>
InputParameters
validParams<SiC>()
{
  InputParameters params = validParams<Material>();

  return params;
}

SiC::SiC(const InputParameters & parameters)
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
SiC::computeQpProperties()
{
  _specific_heat[_qp] = 1000.0; // (J/kg-K)
  _thermal_conductivity[_qp] = 300.0;       // (W/m-K)
  _electrical_conductivity[_qp] = 1000.0;       // (S/m)
  _density[_qp] = 3210.0;       // (kg/m^3)
}
