#include "lionApp.h"

#include "ElectricPotential.h"
#include "CurrentAux.h"
#include "SiC.h"
#include "Graphite.h"
#include "HeatConduction.h"

#include "InterpolateFunction.h"
#include "InterpolateFunction3pt.h"

#include "ControlledFunctionPenaltyDirichletBC.h"


#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<lionApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

lionApp::lionApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  lionApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  lionApp::associateSyntax(_syntax, _action_factory);
  
  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  lionApp::registerExecFlags(_factory);
}

lionApp::~lionApp() {}

void
lionApp::registerApps()
{
  registerApp(lionApp);
}

void
lionApp::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"lionApp"});
    registerKernel(ElectricPotential);
    registerKernel(HeatConductionKernel);
    registerAux(CurrentAux);
    registerMaterial(SiC);
    registerMaterial(Graphite);
    registerFunction(InterpolateFunction);
    registerFunction(InterpolateFunction3pt);
    registerBoundaryCondition(ControlledFunctionPenaltyDirichletBC);

}

void
lionApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"lionApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
lionApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
lionApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
lionApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
lionApp__registerApps()
{
  lionApp::registerApps();
}

extern "C" void
lionApp__registerObjects(Factory & factory)
{
  lionApp::registerObjects(factory);
}

extern "C" void
lionApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  lionApp::associateSyntax(syntax, action_factory);
}

extern "C" void
lionApp__registerExecFlags(Factory & factory)
{
  lionApp::registerExecFlags(factory);
}
