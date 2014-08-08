// CREATED  19 November 2013
// MODIFIED 29 April 2014

// COMPILE make

// OBSOLETE COMPILE g++ -std=c++0x -g -o WeeklyDDprojections -I/usr/include /usr/lib/prob.o Projections.cxx vonMisesRecDist.cxx WeeklyDDprojections.cpp

// PURPOSE project biomass long into the future using a weekly delay difference model according to
//         1. a set of delay difference parameters
//         2. 

#include <fstream>
#include <sstream>

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <cstdlib>
#include <cassert>

#include "std_lib_facilities.h"
#include "UsefulFunctions.h"

using namespace std;

// Global variables
double rho, wk, wk_1, M;
double CatchabilityScalingFactor, BiomassScalingFactor,RecruitmentScalingFactor;
int NWPY;

int Projections(const long unsigned int max_timestep, const double &TargetedEffort, const std::vector<double> &NontargetedEffort, const std::vector<double> &par, std::vector<double> &PropMature, std::vector<double> &SrPar, std::vector<double> &FishingPattern, std::vector<double> &Availability);

int main(int argc, char *argv[]){

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //// Read the values of fixed parameters from file in local directory into global variables
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  string FixParfilename = "FixParameters.txt";
  //display_file(FixParfilename);

  rho = fill_from_file(FixParfilename, "Brody growth coefficient");
  wk = fill_from_file(FixParfilename, "Estimated weight at 22 weeks");
  wk_1 = fill_from_file(FixParfilename, "Parameter defining weight week 21");
  M = fill_from_file(FixParfilename, "Natural mortality");
  CatchabilityScalingFactor = fill_from_file(FixParfilename, "Catchability scaling factor");
  BiomassScalingFactor = fill_from_file(FixParfilename, "Biomass scaling factor");
  RecruitmentScalingFactor = fill_from_file(FixParfilename, "Recruitment scaling factor");
  NWPY = (int) fill_from_file(FixParfilename, "Number of weeks in a year");


  const int NbYear = 150;

    // Read single column file containing parameters 
    std::ifstream ParFile(argv[1]);
    std::vector< double > Par;
    double a;

    while(ParFile >> a){
      Par.push_back(a);}
    ParFile.close();
    
    cout << "Read in " << Par.size() << " estimated parameters from catch and effort data\n";

    // Read single column file containing the proportion of biomass sexually mature in each week
    std::ifstream MaturityFile(argv[2]);
    std::vector< double > PropMature;

    while(MaturityFile >> a){
      PropMature.push_back(a);}
    assert(PropMature.size() == NWPY);
    MaturityFile.close();

    cout << "Read in " << PropMature.size() << " proportion of sexually mature biomass\n";

    // Read single column file containing the stock recruitment parameters
    std::ifstream SRFile(argv[3]);
    std::vector< double > SrPar;

    while(SRFile >> a){
      SrPar.push_back(a);}
    assert(SrPar.size() == 3);
    SRFile.close();

    cout << "Read in " << SrPar.size() << " stock recruitment parameters\n";

    // Read single column file the fishing pattern
    std::ifstream FishingPatternFile(argv[4]);
    std::vector< double > FishingPattern;

    while(FishingPatternFile >> a){
      FishingPattern.push_back(a);}
    assert(FishingPattern.size() == NWPY);
    FishingPatternFile.close();

    cout << "Read in " << FishingPattern.size() << " fishing pattern values\n";

    // Read single column file the availability
    std::ifstream AvailabilityFile(argv[5]);
    std::vector< double > Availability;

    while(AvailabilityFile >> a){
      Availability.push_back(a);}
    assert(Availability.size() == NWPY);
    AvailabilityFile.close();

    cout << "Read in " << Availability.size() << " availability values\n";

    // Total targeted effort in a year is given as an input
    double n = strtod(argv[6],NULL);
    printf("Total effort per year is: %f\n",n);


    // Non-targeted effort is assumed to be null
    std::vector< double >   NontargetedEffort(NbYear * NWPY, 0.0);//, proj_biomass(NbYear * NWPY, 0.0);

 
    // Perform projections and write results to file
    Projections(NbYear*NWPY, n, NontargetedEffort, Par, PropMature, SrPar, FishingPattern, Availability);
    
  return 0;

}