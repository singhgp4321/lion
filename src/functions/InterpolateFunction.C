// This function interpolates the value of two functions. Let's say on a boundary AB
// functionA provides values at point A and functionB provides value at point B. The
// InterpolateFunction will take the values of these two functions and provide the
// inter/extrpolated value at any point on/outside the boundary AB
//
#include "InterpolateFunction.h"

template <>
InputParameters
validParams<InterpolateFunction>()
{
  InputParameters params = validParams<Function>();
  params.addRequiredParam<std::vector<FunctionName>>(
      "functions", "This function will return Sum_over_i(w_i * functions_i)");
  params.addRequiredParam<std::vector<Real>>(
      "w", "This function will return Sum_over_i(w_i * functions_i)");
  params.addClassDescription("Returns the linear combination of the functions");
  return params;
}

InterpolateFunction::InterpolateFunction(const InputParameters & parameters)
  : Function(parameters), FunctionInterface(this), _w(getParam<std::vector<Real>>("w"))
{

  const std::vector<FunctionName> & names = getParam<std::vector<FunctionName>>("functions");
  const unsigned int len = names.size();
  if (len != _w.size())
    mooseError(
        "InterpolateFunction: The number of functions must equal the number of w values");

  _f.resize(len);
  for (unsigned i = 0; i < len; ++i)
  {
    if (name() == names[i])
      mooseError("A InterpolateFunction must not reference itself");
    Function * const f = &getFunctionByName(names[i]);
    if (!f)
      mooseError("InterpolateFunction: The function ",
                 names[i],
                 " (referenced by ",
                 name(),
                 ") cannot be found");
    _f[i] = f;
  }
}

Real
InterpolateFunction::value(Real t, const Point & p)
{
  Real val = 0;
  //for (unsigned i = 0; i < _f.size(); ++i
    val = _f[1]->value(t, p) + (_f[0]->value(t, p)-_f[1]->value(t, p))*(p(1)-_w[1])/(_w[0]-_w[1]);
    //_w[i] * _f[i]->value(t, p);
  return val;
}

RealGradient
InterpolateFunction::gradient(Real t, const Point & p)
{
  RealGradient g;
//  for (unsigned i = 0; i < _f.size(); ++i)
    g = _f[1]->gradient(t, p) + (_f[0]->gradient(t, p)-_f[1]->gradient(t, p))*(p(1)-_w[1])/(_w[0]-_w[1]);
    //_w[i] * _f[i]->gradient(t, p);
  return g;
}

RealVectorValue
InterpolateFunction::vectorValue(Real t, const Point & p)
{
  RealVectorValue v;
//  for (unsigned i = 0; i < _f.size(); ++i)
    v = _f[1]->vectorValue(t, p) + (_f[0]->vectorValue(t, p)-_f[1]->vectorValue(t, p))*(p(1)-_w[1])/(_w[0]-_w[1]);
    //_w[i] * _f[i]->vectorValue(t, p);
  return v;
}
