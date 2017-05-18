// Copyright (c) 2017, vpotseluyko. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:math';

var ACCURACY = 15;

/**
 * Returns X between bLeft and bRight where |F(X)| is min
 * X is chosen by adding step to bLeft while bLeft <= bRight
 */
double GetMinOnSection(Function F, double bLeft, double bRight, double step) {
  double Fmin, Xmin = bLeft;
  for (Fmin = F(bLeft).abs(); bLeft <= bRight; bLeft += step) {
    if (Fmin > F(bLeft).abs()) {
      Fmin = F(bLeft).abs();
      Xmin = bLeft;
    }
  }
  return Xmin;
}

/**
 * Get accuracy level by step value, example:
 * -- step -- accuracy
 * --  1.0 --   0
 * --  0.1 --   1
 * -- 0.01 --   2
 * etc til accuracy level 15
 */
int GetInitialAccuracyRec(double step, {int accuracy: 0}) =>
    (step == 1.0) ? accuracy : GetInitialAccuracyRec(step * 10, accuracy: accuracy + 1);


/**
 * Returns the closest to root value for given section with given initial step
 */
double GetRoot(Function F, double bLeft, double bRight, {double step: 1.0}) {
  double root;
  for (int accuracy = GetInitialAccuracyRec(step); accuracy < ACCURACY; accuracy++) {
    root = GetMinOnSection(F, bLeft, bRight, step);
    root = (root * pow(10, accuracy)).roundToDouble() / pow(10, accuracy);
    bLeft = root - step;
    bRight = root + step;
    step /= 10;
  }
  return root;
}


main() {
  F(double x) => 2 * pow(x, 3) - pow(x, 2) - 7 * x + 5;
  // 2x^3 - x^2 - 7x + 5
  print(GetRoot(F, -3.0, 0.0, step: 0.01));
  print(GetRoot(F, -1.0, 1.0, step: 0.01));
  print(GetRoot(F, 1.0, 2.0, step: 0.01));
}


