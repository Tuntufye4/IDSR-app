import 'package:flutter/material.dart';
import '/models/idsr_case.dart';
import '/api/idsr_api.dart';

class FormPage extends StatefulWidget {
  final IdsrApi api;

  const FormPage({Key? key, required this.api}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _villageController = TextEditingController();
  final _taController = TextEditingController();
  final _healthFacilityController = TextEditingController();
  final _districtController = TextEditingController();
  final _regionController = TextEditingController();
  final _diagnosisTypeController = TextEditingController();
  final _specimenTypeController = TextEditingController();
  final _labNameController = TextEditingController();
  final _reporterNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _formCompletedByController = TextEditingController();
  final _healthFacilityCodeController = TextEditingController();
  final _districtCodeController = TextEditingController();
  final _formVersionController = TextEditingController();
  final _observationsController = TextEditingController();
  final _travelDestinationController = TextEditingController();

  // Dropdowns
  String? _sex;
  String? _disease;
  String? _caseClassification;
  String? _outcome;
  String? _specimenCollected;
  String? _specimenSentToLab;
  String? _labResult;
  String? _finalCaseClassification;
  String? _vaccinationStatus;
  String? _contactWithConfirmedCase;
  String? _recentTravelHistory;

  // Dates
  DateTime? _dob;
  DateTime? _dateOnsetSymptoms;
  DateTime? _dateFirstSeen;
  DateTime? _dateOfDeath;
  DateTime? _dateSpecimenCollected;
  DateTime? _dateResultReceived;
  DateTime? _dateLastVaccination;
  DateTime? _dateReported;
  DateTime? _dateFormCompleted;

  // Numeric
  int? _reportingWeekNumber;
  int? _year;

  final _yesNoUnknown = ['Yes', 'No', 'Unknown'];
  final _outcomes = ['Alive', 'Recovered', 'Deceased'];
  final _labResults = ['Positive', 'Negative', 'Pending'];
  final _finalClassifications = ['Confirmed', 'Discarded', 'Unknown'];
  final _vaccinationStatusList = ['Vaccinated', 'Not Vaccinated', 'Unknown'];
  final _travelHistoryOptions = ['Yes', 'No'];

  // Section expanded states
  bool _patientInfoExpanded = true;
  bool _clinicalInfoExpanded = true;
  bool _specimenLabInfoExpanded = true;
  bool _vaccinationContactExpanded = true;
  bool _reporterInfoExpanded = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _nationalIdController.dispose();
    _villageController.dispose();
    _taController.dispose();
    _healthFacilityController.dispose();
    _districtController.dispose();
    _regionController.dispose();
    _diagnosisTypeController.dispose();
    _specimenTypeController.dispose();
    _labNameController.dispose();
    _reporterNameController.dispose();
    _designationController.dispose();
    _contactNumberController.dispose();
    _formCompletedByController.dispose();
    _healthFacilityCodeController.dispose();
    _districtCodeController.dispose();
    _formVersionController.dispose();
    _observationsController.dispose();
    _travelDestinationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
      String label, DateTime? value, Function(DateTime) onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) onPicked(picked);
  }

  Widget _dateRow(String label, DateTime? value, void Function(DateTime) onPick) {
    return Row(
      children: [
        Expanded(
            child: Text(value == null
                ? '$label not set'
                : '$label: ${value.toIso8601String().split("T")[0]}')),
        TextButton(onPressed: () => _pickDate(label, value, onPick), child: const Text('Pick Date')),
      ],
    );
  }

  Widget _textField(String label, TextEditingController controller,
      {TextInputType? type}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }

  Widget _dropdownField(
      String label, String? value, List<String> options, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: value,
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Required' : null,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final caseData = IdsrCase(
      fullName: _fullNameController.text,
      age: int.tryParse(_ageController.text),
      sex: _sex,
      dateOfBirth: _dob,
      nationalId: _nationalIdController.text,
      village: _villageController.text,
      traditionalAuthority: _taController.text,
      healthFacility: _healthFacilityController.text,
      district: _districtController.text,
      region: _regionController.text,
      dateOnsetSymptoms: _dateOnsetSymptoms,
      dateFirstSeen: _dateFirstSeen,
      disease: _disease,
      caseClassification: _caseClassification,
      outcome: _outcome,
      dateOfDeath: _dateOfDeath,
      diagnosisType: _diagnosisTypeController.text,
      specimenCollected: _specimenCollected,
      dateSpecimenCollected: _dateSpecimenCollected,
      specimenType: _specimenTypeController.text,
      labName: _labNameController.text,
      specimenSentToLab: _specimenSentToLab,
      labResult: _labResult,
      dateResultReceived: _dateResultReceived,
      finalCaseClassification: _finalCaseClassification,
      vaccinationStatus: _vaccinationStatus,
      dateLastVaccination: _dateLastVaccination,
      contactWithConfirmedCase: _contactWithConfirmedCase,
      recentTravelHistory: _recentTravelHistory,
      travelDestination: _travelDestinationController.text,
      reporterName: _reporterNameController.text,
      designation: _designationController.text,
      contactNumber: _contactNumberController.text,
      dateReported: _dateReported,
      formCompletedBy: _formCompletedByController.text,
      dateFormCompleted: _dateFormCompleted,
      reportingWeekNumber: _reportingWeekNumber,
      year: _year,
      healthFacilityCode: _healthFacilityCodeController.text,
      districtCode: _districtCodeController.text,
      formVersion: _formVersionController.text,
      observations: _observationsController.text,
    );

    final result = await widget.api.submitCase(caseData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result ? 'Case submitted successfully' : 'Submission failed')),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _ageController.clear();
    _nationalIdController.clear();
    _villageController.clear();
    _taController.clear();
    _healthFacilityController.clear();
    _districtController.clear();
    _regionController.clear();
    _diagnosisTypeController.clear();
    _specimenTypeController.clear();
    _labNameController.clear();
    _reporterNameController.clear();
    _designationController.clear();
    _contactNumberController.clear();
    _formCompletedByController.clear();
    _healthFacilityCodeController.clear();
    _districtCodeController.clear();
    _formVersionController.clear();
    _observationsController.clear();
    _travelDestinationController.clear();

    setState(() {
      _sex = null;
      _disease = null;
      _caseClassification = null;
      _outcome = null;
      _specimenCollected = null;
      _specimenSentToLab = null;
      _labResult = null;
      _finalCaseClassification = null;
      _vaccinationStatus = null;
      _contactWithConfirmedCase = null;
      _recentTravelHistory = null;

      _dob = null;
      _dateOnsetSymptoms = null;
      _dateFirstSeen = null;
      _dateOfDeath = null;
      _dateSpecimenCollected = null;
      _dateResultReceived = null;
      _dateLastVaccination = null;
      _dateReported = null;
      _dateFormCompleted = null;

      _reportingWeekNumber = null;
      _year = null;

      _patientInfoExpanded = false;
      _clinicalInfoExpanded = false;
      _specimenLabInfoExpanded = false;
      _vaccinationContactExpanded = false;
      _reporterInfoExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpansionTile(
                initiallyExpanded: _patientInfoExpanded,
                title: const Text('Patient Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _textField('Full Name', _fullNameController),
                  const SizedBox(height: 10),
                  _textField('Age', _ageController, type: TextInputType.number),
                  const SizedBox(height: 10),
                  _dropdownField('Sex', _sex, ['Male', 'Female'], (v) => setState(() => _sex = v)),
                  const SizedBox(height: 10),
                  _textField('National ID', _nationalIdController),
                  const SizedBox(height: 10),
                  _textField('Village', _villageController),
                  const SizedBox(height: 10),
                  _textField('Traditional Authority', _taController),
                  const SizedBox(height: 10),
                  _textField('Health Facility', _healthFacilityController),
                  const SizedBox(height: 10),
                  _textField('District', _districtController),
                  const SizedBox(height: 10),
                  _textField('Region', _regionController),  
                  const SizedBox(height: 10),
                  _dateRow('Date of Birth', _dob, (d) => setState(() => _dob = d)),
                ],
              ),

              ExpansionTile(
                initiallyExpanded: _clinicalInfoExpanded,
                title: const Text('Clinical Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _dateRow('Date of Onset', _dateOnsetSymptoms, (d) => setState(() => _dateOnsetSymptoms = d)),
                  const SizedBox(height: 10),
                  _dateRow('Date First Seen', _dateFirstSeen, (d) => setState(() => _dateFirstSeen = d)),
                  const SizedBox(height: 10),
                  _dropdownField('Disease', _disease, ['Cholera','Plague','Yellow','fever','Ebola virus','Marburg virus','Measles','Polio','Meningitis','Anthrax','Rabies','COVID-19','Typhoid','Dysentery','Malaria','Tuberculosis','HIV/AIDS'], (v) => setState(() => _disease = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Classification', _caseClassification, ['Suspected', 'Probable', 'Confirmed'], (v) => setState(() => _caseClassification = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Outcome', _outcome, _outcomes, (v) => setState(() => _outcome = v)),
                  if (_outcome == 'Deceased') 
                    _dateRow('Date of Death', _dateOfDeath, (d) => setState(() => _dateOfDeath = d)),
                  const SizedBox(height: 10),
                  _textField('Diagnosis Type', _diagnosisTypeController),
                ],
              ),

              ExpansionTile(
                initiallyExpanded: _specimenLabInfoExpanded,
                title: const Text('Specimen & Lab Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _dropdownField('Specimen Collected', _specimenCollected, _yesNoUnknown, (v) => setState(() => _specimenCollected = v)),
                  const SizedBox(height: 10),
                  if (_specimenCollected == 'Yes') ...[
                    _dateRow('Date Specimen Collected', _dateSpecimenCollected, (d) => setState(() => _dateSpecimenCollected = d)),
                    const SizedBox(height: 10),
                    _textField('Specimen Type', _specimenTypeController),
                  ],
                  const SizedBox(height: 10),
                  _dropdownField('Specimen Sent to Lab', _specimenSentToLab, _yesNoUnknown, (v) => setState(() => _specimenSentToLab = v)),
                  const SizedBox(height: 10),
                  if (_specimenSentToLab == 'Yes') ...[
                    _textField('Lab Name', _labNameController),
                    const SizedBox(height: 10),
                    _dropdownField('Lab Result', _labResult, _labResults, (v) => setState(() => _labResult = v)),
                    const SizedBox(height: 10),
                    _dateRow('Date Result Received', _dateResultReceived, (d) => setState(() => _dateResultReceived = d)),
                  ],
                  const SizedBox(height: 10),
                  _dropdownField('Final Case Classification', _finalCaseClassification, _finalClassifications, (v) => setState(() => _finalCaseClassification = v)),
                ],
              ),

              ExpansionTile(
                initiallyExpanded: _vaccinationContactExpanded,
                title: const Text('Vaccination & Contact History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _dropdownField('Vaccination Status', _vaccinationStatus, _vaccinationStatusList, (v) => setState(() => _vaccinationStatus = v)),
                  const SizedBox(height: 10),
                  if (_vaccinationStatus == 'Vaccinated') 
                    _dateRow('Date Last Vaccination', _dateLastVaccination, (d) => setState(() => _dateLastVaccination = d)),
                  const SizedBox(height: 10),
                  _dropdownField('Contact with Confirmed Case', _contactWithConfirmedCase, _yesNoUnknown, (v) => setState(() => _contactWithConfirmedCase = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Recent Travel History', _recentTravelHistory, _travelHistoryOptions, (v) => setState(() => _recentTravelHistory = v)),
                  const SizedBox(height: 10),
                  if (_recentTravelHistory == 'Yes') 
                    _textField('Travel Destination', _travelDestinationController),
                ],
              ),

              ExpansionTile(
                initiallyExpanded: _reporterInfoExpanded,
                title: const Text('Reporter Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _textField('Reporter Name', _reporterNameController),
                  const SizedBox(height: 10),
                  _textField('Designation', _designationController),
                  const SizedBox(height: 10),
                  _textField('Contact Number', _contactNumberController),
                  const SizedBox(height: 10),
                  _dateRow('Date Reported', _dateReported, (d) => setState(() => _dateReported = d)),
                  const SizedBox(height: 10),
                  _textField('Form Completed By', _formCompletedByController),
                  const SizedBox(height: 10),
                  _dateRow('Date Form Completed', _dateFormCompleted, (d) => setState(() => _dateFormCompleted = d)),
                  const SizedBox(height: 10),
                  _textField('Health Facility Code', _healthFacilityCodeController),
                  const SizedBox(height: 10),
                  _textField('District Code', _districtCodeController),
                  const SizedBox(height: 10),
                  _textField('Form Version', _formVersionController),
                  const SizedBox(height: 10),
                  _textField('Observations', _observationsController),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearForm,
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
     