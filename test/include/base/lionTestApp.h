//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef LIONTESTAPP_H
#define LIONTESTAPP_H

#include "MooseApp.h"

class lionTestApp;

template <>
InputParameters validParams<lionTestApp>();

class lionTestApp : public MooseApp
{
public:
  lionTestApp(InputParameters parameters);
  virtual ~lionTestApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* LIONTESTAPP_H */
