#define CONC true          //include concentration on the boundary
#define BULKPOL false         //don't include internal active fluid
#define WALLS false         //don't include walls
const int Lx = 120;         //number of point in x direction
const int Ly = 120;          //number of points in y direction
 
double ST=0.1;    //bare surface tension
double Zc=-0.01;    //boundary activity
double koff=0.85;    //boundary unbinding rate
