//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef INTERPOLATEFUNCTION_H
#define INTERPOLATEFUNCTION_H

#include "Function.h"
#include "FunctionInterface.h"

class InterpolateFunction;

template <>
InputParameters validParams<InterpolateFunction>();

/**
 * Sum_over_i (w_i * functions_i)
 */
class InterpolateFunction : public Function, protected FunctionInterface
{
public:
  InterpolateFunction(const InputParameters & parameters);

  virtual Real value(Real t, const Point & pt) override;
  virtual RealVectorValue vectorValue(Real t, const Point & p) override;
  virtual RealGradient gradient(Real t, const Point & p) override;

private:
  std::vector<Real> _w;

  std::vector<Function *> _f;
};

#endif // INTERPOLATEFUNCTION_H
