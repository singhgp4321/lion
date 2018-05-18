//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ElectricPotential.h"


template <>
InputParameters
validParams<ElectricPotential>()
{
  InputParameters params = validParams<Kernel>();
  return params;
}

ElectricPotential::ElectricPotential(const InputParameters & parameters)
    : Kernel(parameters),
    _electrical_conductivity(getMaterialProperty<Real>("electrical_conductivity"))
{
}

Real
ElectricPotential::computeQpResidual()
{
  return _electrical_conductivity[_qp] * _grad_u[_qp] * _grad_test[_i][_qp];
}

Real
ElectricPotential::computeQpJacobian()
{
  return _electrical_conductivity[_qp] * _grad_phi[_j][_qp] * _grad_test[_i][_qp];
}
