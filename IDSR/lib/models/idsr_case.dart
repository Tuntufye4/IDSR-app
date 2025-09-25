class IdsrCase {
  final int? id; // backend-generated ID
  final String? fullName;
  final int? age;
  final String? sex;   
  final DateTime? dateOfBirth;
  final String? nationalId;

  final String? village;
  final String? traditionalAuthority;
  final String? healthFacility;
  final String? district;
  final String? region;

  final DateTime? dateOnsetSymptoms;
  final DateTime? dateFirstSeen;
  final String? disease;
  final String? caseClassification;
  final String? outcome;
  final DateTime? dateOfDeath;

  final String? diagnosisType;
  final String? specimenCollected;
  final DateTime? dateSpecimenCollected;
  final String? specimenType;
  final String? labName;
  final String? specimenSentToLab;
  final String? labResult;
  final DateTime? dateResultReceived;
  final String? finalCaseClassification;

  final String? vaccinationStatus;
  final DateTime? dateLastVaccination;
  final String? contactWithConfirmedCase;
  final String? recentTravelHistory;
  final String? travelDestination;

  final String? reporterName;
  final String? designation;
  final String? contactNumber;
  final DateTime? dateReported;
  final String? formCompletedBy;
  final DateTime? dateFormCompleted;

  final int? reportingWeekNumber;
  final int? year;
  final String? healthFacilityCode;
  final String? districtCode;
  final String? formVersion;

  final String? observations;

  IdsrCase({
    this.id,
    this.fullName,
    this.age,
    this.sex,
    this.dateOfBirth,
    this.nationalId,
    this.village,
    this.traditionalAuthority,
    this.healthFacility,
    this.district,
    this.region,
    this.dateOnsetSymptoms,
    this.dateFirstSeen,
    this.disease,
    this.caseClassification,
    this.outcome,
    this.dateOfDeath,
    this.diagnosisType,
    this.specimenCollected,
    this.dateSpecimenCollected,
    this.specimenType,
    this.labName,
    this.specimenSentToLab,
    this.labResult,
    this.dateResultReceived,
    this.finalCaseClassification,
    this.vaccinationStatus,
    this.dateLastVaccination,
    this.contactWithConfirmedCase,
    this.recentTravelHistory,
    this.travelDestination,
    this.reporterName,
    this.designation,
    this.contactNumber,
    this.dateReported,
    this.formCompletedBy,
    this.dateFormCompleted,
    this.reportingWeekNumber,
    this.year,
    this.healthFacilityCode,
    this.districtCode,
    this.formVersion,
    this.observations,
  });

  factory IdsrCase.fromJson(Map<String, dynamic> json) => IdsrCase(
        id: json['id'],
        fullName: json['full_name'],
        age: json['age'],
        sex: json['sex'],
        dateOfBirth: _parseDate(json['date_of_birth']),
        nationalId: json['national_id'],
        village: json['village'],
        traditionalAuthority: json['traditional_authority'],
        healthFacility: json['health_facility'],
        district: json['district'],
        region: json['region'],
        dateOnsetSymptoms: _parseDate(json['date_onset_symptoms']),
        dateFirstSeen: _parseDate(json['date_first_seen']),
        disease: json['disease'],
        caseClassification: json['case_classification'],
        outcome: json['outcome'],
        dateOfDeath: _parseDate(json['date_of_death']),
        diagnosisType: json['diagnosis_type'],
        specimenCollected: _toString(json['specimen_collected']),
        dateSpecimenCollected: _parseDate(json['date_specimen_collected']),
        specimenType: json['specimen_type'],
        labName: json['lab_name'],
        specimenSentToLab: _toString(json['specimen_sent_to_lab']),
        labResult: json['lab_result'],
        dateResultReceived: _parseDate(json['date_result_received']),
        finalCaseClassification: json['final_case_classification'],
        vaccinationStatus: json['vaccination_status'],
        dateLastVaccination: _parseDate(json['date_last_vaccination']),
        contactWithConfirmedCase: _toString(json['contact_with_confirmed_case']),
        recentTravelHistory: _toString(json['recent_travel_history']),
        travelDestination: json['travel_destination'],
        reporterName: json['reporter_name'],
        designation: json['designation'],
        contactNumber: json['contact_number'],
        dateReported: _parseDate(json['date_reported']),
        formCompletedBy: json['form_completed_by'],
        dateFormCompleted: _parseDate(json['date_form_completed']),
        reportingWeekNumber: json['reporting_week_number'],
        year: json['year'],
        healthFacilityCode: json['health_facility_code'],
        districtCode: json['district_code'],
        formVersion: json['form_version'],
        observations: json['observations'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'age': age,
        'sex': sex,
        'date_of_birth': _formatDate(dateOfBirth),
        'national_id': nationalId,
        'village': village,
        'traditional_authority': traditionalAuthority,
        'health_facility': healthFacility,
        'district': district,
        'region': region,
        'date_onset_symptoms': _formatDate(dateOnsetSymptoms),
        'date_first_seen': _formatDate(dateFirstSeen),
        'disease': disease,
        'case_classification': caseClassification,
        'outcome': outcome,
        'date_of_death': _formatDate(dateOfDeath),
        'diagnosis_type': diagnosisType,
        'specimen_collected': specimenCollected,
        'date_specimen_collected': _formatDate(dateSpecimenCollected),
        'specimen_type': specimenType,
        'lab_name': labName,
        'specimen_sent_to_lab': specimenSentToLab,
        'lab_result': labResult,
        'date_result_received': _formatDate(dateResultReceived),
        'final_case_classification': finalCaseClassification,
        'vaccination_status': vaccinationStatus,
        'date_last_vaccination': _formatDate(dateLastVaccination),
        'contact_with_confirmed_case': contactWithConfirmedCase,
        'recent_travel_history': recentTravelHistory,
        'travel_destination': travelDestination,
        'reporter_name': reporterName,
        'designation': designation,
        'contact_number': contactNumber,
        'date_reported': _formatDate(dateReported),
        'form_completed_by': formCompletedBy,
        'date_form_completed': _formatDate(dateFormCompleted),
        'reporting_week_number': reportingWeekNumber,
        'year': year,
        'health_facility_code': healthFacilityCode,
        'district_code': districtCode,
        'form_version': formVersion,
        'observations': observations,
      };

  // Helpers
  static DateTime? _parseDate(dynamic value) {
    if (value == null || value == '') return null;
    return DateTime.tryParse(value.toString());
  }

  static String? _toString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String().split('T')[0];
  }
}
   