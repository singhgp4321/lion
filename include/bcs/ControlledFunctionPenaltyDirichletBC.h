//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef CONTROLLEDFUNCTIONPENALTYDIRICHLETBC_H
#define CONTROLLEDFUNCTIONPENALTYDIRICHLETBC_H

#include "IntegratedBC.h"

class ControlledFunctionPenaltyDirichletBC;
class Function;

template <>
InputParameters validParams<ControlledFunctionPenaltyDirichletBC>();

/**
 * A different approach to applying Dirichlet BCs
 *
 * uses \f$ \int(p u \cdot \phi)=\int(p f \cdot \phi)\f$ on \f$d\omega\f$
 *
 */

class ControlledFunctionPenaltyDirichletBC : public IntegratedBC
{
public:
  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  ControlledFunctionPenaltyDirichletBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

  Function & _func;

private:
  Real _p;
};

#endif
