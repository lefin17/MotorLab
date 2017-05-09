class RecordResult
{
// 2017-05-09 log file with result getting from controller and sened to it in integer values

String FileName;
Table results;
boolean active = false;

 void RecordResult()
 {
 
 }
 
 void StartRecord()
   {
     active = true;
   }
   
 void CreateTable()
   {
    results = new Table();
    results.addColumn("id"); //identical number of record
    results.addColumn("time"); //current time in computer
    results.addColumn("outA"); //command to pump
    results.addColumn("outB"); //command to driver of the motor
    results.addColumn("outC"); //command to driver of the linear 
    results.addColumn("out"); //reserved output to record in list (empty column)
  
  results.addColumn("pPumpA"); //pressure in high line near the pump. 
  results.addColumn("pPumpB");
  results.addColumn("pLinearA");
  results.addColumn("pLinearB");
  results.addColumn("pMotorA");
  results.addColumn("pMotorB");
  
  results.addColumn("posPump");
  results.addColumn("posMotor");
  results.addColumn("posLinear"); 
   }

void AddRowToResult(int outA, int outB, int outC, int pPumpA, int pPumpB, int  pLinearA, int  pLinearB, int pMotorA, int pMotorB, int posPump, int posMotor, int posLinear)
  {
     TableRow newRow = results.addRow();
     newRow.setInt("id", results.getRowCount() - 1);
     newRow.setString("time", timeYMD());
     newRow.setInt("outA", outA);
     newRow.setInt("outB", outB);
     newRow.setInt("outC", outC);
     newRow.setInt("pPumpA", pPumpA);     
     newRow.setInt("pPumpB", pPumpB);
     newRow.setInt("pLinearA", pLinearA);
     newRow.setInt("pLinearB", pLinearB);
     newRow.setInt("pMotorA", pMotorA);
     newRow.setInt("pMotorB", pMotorB);
     newRow.setInt("posPump", posPump);
     newRow.setInt("posLinear", posLinear);
     newRow.setInt("posMotor", posMotor);
  }
String timeYMD()
  {
    String res;
    res = String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + " " + String.valueOf(hour()) + ":" + String.valueOf(minute()) + ":" + String.valueOf(second());
    return res;
  }
String dateYMD()
  {
    String res;
    res = String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "_" + String.valueOf(hour()) + String.valueOf(minute()) + String.valueOf(second());
    return res;
  }
 
 void SaveResult()  
 {
   saveTable(results, "data/results"+dateYMD()+".csv");
   active = false;
   CreateTable();
 }
 
}