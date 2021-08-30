//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "WaveTestApp.h"
#include "WaveApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

InputParameters
WaveTestApp::validParams()
{
  InputParameters params = WaveApp::validParams();
  return params;
}

WaveTestApp::WaveTestApp(InputParameters parameters) : MooseApp(parameters)
{
  WaveTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

WaveTestApp::~WaveTestApp() {}

void
WaveTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  WaveApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"WaveTestApp"});
    Registry::registerActionsTo(af, {"WaveTestApp"});
  }
}

void
WaveTestApp::registerApps()
{
  registerApp(WaveApp);
  registerApp(WaveTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
WaveTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  WaveTestApp::registerAll(f, af, s);
}
extern "C" void
WaveTestApp__registerApps()
{
  WaveTestApp::registerApps();
}
