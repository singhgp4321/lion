// This function interpolates the value of two functions. Let's say on a boundary ABC
// functionA provides values at point A and C, and functionB provides value at point B
// and functionC provides value at point C. The
// InterpolateFunction3pt will take the values of these three functions and provide the
// inter/extrapolated value at any point on/outside the boundary ABC
//
#include "InterpolateFunction3pt.h"

template <>
InputParameters
validParams<InterpolateFunction3pt>()
{
  InputParameters params = validParams<Function>();
  params.addRequiredParam<std::vector<FunctionName>>(
      "functions", "This function will interpolate the three functions");
  params.addRequiredParam<std::vector<Real>>(
      "w", "This function will interpolate the three functions");
  params.addClassDescription("Returns the linear combination of the functions");
  return params;
}

InterpolateFunction3pt::InterpolateFunction3pt(const InputParameters & parameters)
  : Function(parameters), FunctionInterface(this), _w(getParam<std::vector<Real>>("w"))
{

  const std::vector<FunctionName> & names = getParam<std::vector<FunctionName>>("functions");
  const unsigned int len = names.size();
  if (len != _w.size())
    mooseError(
        "InterpolateFunction3pt: The number of functions must equal the number of w values");

  _f.resize(len);
  for (unsigned i = 0; i < len; ++i)
  {
    if (name() == names[i])
      mooseError("A InterpolateFunction3pt must not reference itself");
    Function * const f = &getFunctionByName(names[i]);
    if (!f)
      mooseError("InterpolateFunction3pt: The function ",
                 names[i],
                 " (referenced by ",
                 name(),
                 ") cannot be found");
    _f[i] = f;
  }
}

Real
InterpolateFunction3pt::value(Real t, const Point & p)
{
  Real val = 0;
  //for (unsigned i = 0; i < _f.size(); ++i
  if (p(1)<_w[0])
    val = _f[0]->value(t, p);
  else if (p(1)>=_w[0] && p(1)<_w[1])
    val = _f[1]->value(t, p) + (_f[0]->value(t, p)-_f[1]->value(t, p))*(p(1)-_w[1])/(_w[0]-_w[1]);
  else if (p(1)>=_w[1] && p(1)<_w[2])
    val = _f[2]->value(t, p) + (_f[1]->value(t, p)-_f[2]->value(t, p))*(p(1)-_w[2])/(_w[1]-_w[2]);
  else
    val = _f[2]->value(t, p);

    //_w[i] * _f[i]->value(t, p);
  return val;
}

RealGradient
InterpolateFunction3pt::gradient(Real t, const Point & p)
{
  RealGradient g;
//  for (unsigned i = 0; i < _f.size(); ++i)
if (p(1)<_w[0])
  g = _f[0]->gradient(t, p);
else if (p(1)>=_w[0] && p(1)<_w[1])
  g = _f[1]->gradient(t, p) + (_f[0]->gradient(t, p)-_f[1]->gradient(t, p))*(p(1)-_w[1])/(_w[0]-_w[1]);
else if (p(1)>=_w[1] && p(1)<_w[2])
  g = _f[2]->gradient(t, p) + (_f[1]->gradient(t, p)-_f[2]->gradient(t, p))*(p(1)-_w[2])/(_w[1]-_w[2]);
else
  g = _f[2]->gradient(t, p);
    //_w[i] * _f[i]->gradient(t, p);
  return g;
}

RealVectorValue
InterpolateFunction3pt::vectorValue(Real t, const Point & p)
{
  RealVectorValue v;
//  for (unsigned i = 0; i < _f.size(); ++i)
if (p(1)<_w[0])
  v = _f[0]->vectorValue(t, p);
else if (p(1)>=_w[0] && p(1)<_w[1])
  v = _f[1]->vectorValue(t, p) + (_f[0]->vectorValue(t, p)-_f[1]->vectorValue(t, p))*(p(1)-_w[1])/(_w[0]-_w[1]);
else if (p(1)>=_w[1] && p(1)<_w[2])
  v = _f[2]->vectorValue(t, p) + (_f[1]->vectorValue(t, p)-_f[2]->vectorValue(t, p))*(p(1)-_w[2])/(_w[1]-_w[2]);
else
  v = _f[2]->vectorValue(t, p);  //_w[i] * _f[i]->vectorValue(t, p);
  return v;
}
