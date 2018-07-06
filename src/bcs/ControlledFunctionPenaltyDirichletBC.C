//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ControlledFunctionPenaltyDirichletBC.h"
#include "Function.h"

template <>
InputParameters
validParams<ControlledFunctionPenaltyDirichletBC>()
{
  InputParameters params = validParams<IntegratedBC>();
  params.addRequiredParam<Real>("penalty", "Penalty scalar");
  params.addRequiredParam<FunctionName>("function", "Forcing function");

  return params;
}

ControlledFunctionPenaltyDirichletBC::ControlledFunctionPenaltyDirichletBC(const InputParameters & parameters)
  : IntegratedBC(parameters), _func(getFunction("function")), _p(getParam<Real>("penalty"))
{
}

Real
ControlledFunctionPenaltyDirichletBC::computeQpResidual()
{
  if (_q_point[_qp](1)>0.0 && _q_point[_qp](1)<0.07)
    {
      _p=0;
    }
  else
    {
      _p=1e5;
    }
  
  return _p * _test[_i][_qp] * (-_func.value(_t, _q_point[_qp]) + _u[_qp]);
}

Real
ControlledFunctionPenaltyDirichletBC::computeQpJacobian()
{
  if (_q_point[_qp](1)>0.0 && _q_point[_qp](1)<0.07)
    {
      _p=0;
    }
  else
    {
      _p=1e5;
    }
  return _p * _phi[_j][_qp] * _test[_i][_qp];
}
