#define CONC true          //include concentration on the boundary
#define BULKPOL false         //don't include internal active fluid
#define WALLS false         //don't include walls
const int Lx = 120;         //number of point in x direction
const int Ly = 120;          //number of points in y direction
 
double ST=5;    //bare surface tension
double Zc=-2.0;    //boundary activity
double koff=1.0;    //boundary unbinding rate
