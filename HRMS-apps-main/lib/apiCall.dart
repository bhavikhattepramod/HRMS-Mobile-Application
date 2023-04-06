class Employee {
  // final int eleft;
  // final String eadd;
  // final String epdate;
  final int id;
  final String name;
  final String jobTitle;
  final String workMobile;
  final String workEmail;
  final String deptName;
  final String managerName;
  final String pan;
  final String accno;
  final String joinDate;
  final String nationality;
  final String idNo;
  final String gender;
  final String maritalStatus;
  final double salaryInfo;

  Employee(
      // {required this.eleft,
      // required this.eadd,
      // required this.epdate,
      {required this.id,
      required this.name,
      required this.jobTitle,
      required this.workMobile,
      required this.workEmail,
      required this.deptName,
      required this.managerName,
      required this.pan,
      required this.accno,
      required this.joinDate,
      required this.nationality,
      required this.idNo,
      required this.gender,
      required this.maritalStatus,
      required this.salaryInfo});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        // eadd: json['Address'],
        //eleft: json['leavesLeft'],
        //epdate: json['paySlipDue'],
        id: json['id'],
        name: json['name'],
        jobTitle: json['job_title '],
        workEmail: json['work_email'],
        workMobile: json['work_mobile'],
        deptName: json['department_name'],
        managerName: json['manager_name'],
        pan: json['pan'],
        accno: json['bank_acc_num'],
        joinDate: json['joining_date'],
        nationality: json['nationality'],
        idNo: json['identification_num'],
        gender: json['gender'],
        maritalStatus: json['marital_status'],
        salaryInfo: json['salary_info']);
  }
}

class Location{
  final String Latitude;
  final String Longitude;
  final String Date;
  

  Location(
   
      {required this.Latitude,
      required this.Longitude,
      required this.Date,
      });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location( 
        Latitude: json['Latitude'],
        Longitude: json['Longitude'],
        Date: json['Date '],
       );
  }
}

class Payslip{
  final String employee_id;
  final String employee_name;
  final String payslip_id;
  final String status;
  final String url;
  

  Payslip(
      {required this.employee_id,
      required this.employee_name,
      required this.payslip_id,
      required this.status,
      required this.url,
      });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
        employee_id: json['employee_id'],
        employee_name: json['employee_name'],
        payslip_id: json['payslip_id '],
        status: json['status '],
        url: json['url '],
       );
  }
}












  
