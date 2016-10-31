#include <opencv2/opencv.hpp>
#include <fstream>
#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <time.h>
#include<sstream>
using namespace cv;
using namespace std;

int main()
{
	ofstream myfile;
	myfile.open ("/home/saikrishna/Appidi_SMAI/test_male.txt");
	unsigned int j;
	for(j=1;j<350;j++)
	{
		//		myfile <<"2 ";
		stringstream ss;
		ss<<j;
//		cout << j << "\n";
		string filename ="/home/saikrishna/Appidi_SMAI/UNRGenderDB/test/Male/"+ss.str()+ ".tif";
			
		ss.str("");
		cout << filename << "\n";

		Mat img_raw =imread(filename,1); // load as color image
		if( !img_raw.data )
		{
			printf( " No image data \n " );
			//			printf("j:%d",j);
			return -1;
		}    

		resize(img_raw, img_raw, Size(12,27));
		//GaussianBlur( img_raw, img_raw, Size( 7, 7 ), 1, 1 );
		Mat img;
		cvtColor(img_raw, img, CV_BGR2HSV); 
		HOGDescriptor d;
		d.winSize=Size(12,27);
		d.cellSize=Size(3,3);
		d.blockSize=Size(6,6);
		d.blockStride=Size(3,3);
		d.nbins=8;

		vector<float> descriptorsValues;
		vector<Point> locations;
		d.compute( img, descriptorsValues, Size(0,0), Size(0,0), locations);
			//framecount++;
			stringstream use;
			use << j;
			string number = use.str();
			string type = ".jpg";
			imwrite("/home/saikrishna/TrafficLight/naya2/"+number+type,img);
	cout << descriptorsValues.size() << "\n";
		myfile << "0 ";  
		for (unsigned int i=0; i<descriptorsValues.size(); i++)
		{
			myfile << i << ":" << descriptorsValues.at(i) << " ";
		}
		myfile<<'\n';
	}

	myfile.close();
}
