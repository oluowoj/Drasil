#include "Calculations.hpp"

#include <math.h>
#include <string>

#include "InputParameters.hpp"

using std::string;

double func_t_flight(InputParameters &inParams, double g_vect) {
    return 2 * inParams.v_launch * sin(inParams.theta) / g_vect;
}

double func_p_land(InputParameters &inParams, double g_vect) {
    return 2 * pow(inParams.v_launch, 2) * sin(inParams.theta) * cos(inParams.theta) / g_vect;
}

double func_d_offset(InputParameters &inParams, double p_land) {
    return p_land - inParams.p_target;
}

string func_s(InputParameters &inParams, double epsilon, double d_offset) {
    if (fabs(d_offset / inParams.p_target) < epsilon) {
        return "The target was hit.";
    }
    else if (d_offset < 0) {
        return "The projectile fell short.";
    }
    else {
        return "The projectile went long.";
    }
}
