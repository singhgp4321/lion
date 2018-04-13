//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "lionTestApp.h"
#include "lionApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<lionTestApp>()
{
  InputParameters params = validParams<lionApp>();
  return params;
}

lionTestApp::lionTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  lionApp::registerObjectDepends(_factory);
  lionApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  lionApp::associateSyntaxDepends(_syntax, _action_factory);
  lionApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  lionApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    lionTestApp::registerObjects(_factory);
    lionTestApp::associateSyntax(_syntax, _action_factory);
    lionTestApp::registerExecFlags(_factory);
  }
}

lionTestApp::~lionTestApp() {}

void
lionTestApp::registerApps()
{
  registerApp(lionApp);
  registerApp(lionTestApp);
}

void
lionTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
lionTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
lionTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
lionTestApp__registerApps()
{
  lionTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
lionTestApp__registerObjects(Factory & factory)
{
  lionTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
lionTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  lionTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
lionTestApp__registerExecFlags(Factory & factory)
{
  lionTestApp::registerExecFlags(factory);
}
