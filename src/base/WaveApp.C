#include "WaveApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
WaveApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  // Do not use legacy material output, i.e., output properties on INITIAL as well as TIMESTEP_END
  params.set<bool>("use_legacy_material_output") = false;

  return params;
}

WaveApp::WaveApp(InputParameters parameters) : MooseApp(parameters)
{
  WaveApp::registerAll(_factory, _action_factory, _syntax);
}

WaveApp::~WaveApp() {}

void
WaveApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAll(f, af, syntax);
  Registry::registerObjectsTo(f, {"WaveApp"});
  Registry::registerActionsTo(af, {"WaveApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
WaveApp::registerApps()
{
  registerApp(WaveApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
WaveApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  WaveApp::registerAll(f, af, s);
}
extern "C" void
WaveApp__registerApps()
{
  WaveApp::registerApps();
}
