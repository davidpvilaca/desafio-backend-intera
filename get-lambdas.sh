#!/bin/sh
cd match &&
npm run --silent build:lambda &&
cd ../openings &&
npm run --silent build:lambda &&
cd ../talents &&
npm run --silent build:lambda &&
cd .. &&
mkdir -p lambdas/match lambdas/openings lambdas/talents &&
cp match/dist/latest.zip lambdas/match &&
cp openings/dist/latest.zip lambdas/openings &&
cp talents/dist/latest.zip lambdas/talents
