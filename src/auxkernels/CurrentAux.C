//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CurrentAux.h"

template <>
InputParameters
validParams<CurrentAux>()
{
  InputParameters params = validParams<AuxKernel>();
  MooseEnum component("x y z");
  params.addClassDescription("Compute components of flux vector for diffusion problems "
                             "$(\\vv{J} = -D \\nabla C)$.");
  params.addRequiredParam<MooseEnum>("component", component, "The desired component of current.");
  params.addRequiredCoupledVar("potential_variable", "The name of the variable");
  return params;
}

CurrentAux::CurrentAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _component(getParam<MooseEnum>("component")),
    _grad_u(coupledGradient("potential_variable")),
    _electrical_conductivity(getMaterialProperty<Real>("electrical_conductivity"))
{
}

Real
CurrentAux::computeValue()
{
  //  return -_grad_u[_qp](_component);
  return -_electrical_conductivity[_qp] * _grad_u[_qp](_component);
}
