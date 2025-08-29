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

  Future<void> _pickDate(String label, DateTime? value, Function(DateTime) onPicked) async {
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
        Expanded(child: Text(value == null ? '$label not set' : '$label: ${value.toIso8601String().split("T")[0]}')),
        TextButton(onPressed: () => _pickDate(label, value, onPick), child: const Text('Pick Date')),
      ],
    );
  }

  Widget _textField(String label, TextEditingController controller, {TextInputType? type}) {
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

  Widget _dropdownField(String label, String? value, List<String> options, void Function(String?) onChanged) {
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

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IDSR Case Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionTitle('Patient Information'),
              _textField('Full Name', _fullNameController),
              _textField('Age', _ageController, type: TextInputType.number),
              _dropdownField('Sex', _sex, ['Male', 'Female'], (v) => setState(() => _sex = v)),
              _textField('National ID', _nationalIdController),
              _textField('Village', _villageController),
              _textField('Traditional Authority', _taController),
              _textField('Health Facility', _healthFacilityController),
              _textField('District', _districtController),
              _textField('Region', _regionController),
              _dateRow('Date of Birth', _dob, (d) => setState(() => _dob = d)),

              _sectionTitle('Clinical Information'),
              _dateRow('Date of Onset', _dateOnsetSymptoms, (d) => setState(() => _dateOnsetSymptoms = d)),
              _dateRow('Date First Seen', _dateFirstSeen, (d) => setState(() => _dateFirstSeen = d)),
              _dropdownField('Disease', _disease, ['Cholera', 'Malaria', 'COVID-19', 'Other'], (v) => setState(() => _disease = v)),
              _dropdownField('Classification', _caseClassification, ['Suspected', 'Probable', 'Confirmed'], (v) => setState(() => _caseClassification = v)),
              _dropdownField('Outcome', _outcome, _outcomes, (v) => setState(() => _outcome = v)),
              if (_outcome == 'Deceased')
                _dateRow('Date of Death', _dateOfDeath, (d) => setState(() => _dateOfDeath = d)),
              _textField('Diagnosis Type', _diagnosisTypeController),

              _sectionTitle('Specimen & Lab Information'),
              _dropdownField('Specimen Collected', _specimenCollected, _yesNoUnknown, (v) => setState(() => _specimenCollected = v)),
              if (_specimenCollected == 'Yes') ...[
                _dateRow('Date Specimen Collected', _dateSpecimenCollected, (d) => setState(() => _dateSpecimenCollected = d)),
                _textField('Specimen Type', _specimenTypeController),
              ],
              _dropdownField('Specimen Sent to Lab', _specimenSentToLab, _yesNoUnknown, (v) => setState(() => _specimenSentToLab = v)),
              if (_specimenSentToLab == 'Yes') ...[
                _textField('Lab Name', _labNameController),
                _dropdownField('Lab Result', _labResult, _labResults, (v) => setState(() => _labResult = v)),
                _dateRow('Date Result Received', _dateResultReceived, (d) => setState(() => _dateResultReceived = d)),
              ],
              _dropdownField('Final Case Classification', _finalCaseClassification, _finalClassifications, (v) => setState(() => _finalCaseClassification = v)),

              _sectionTitle('Vaccination & Contact History'),
              _dropdownField('Vaccination Status', _vaccinationStatus, _vaccinationStatusList, (v) => setState(() => _vaccinationStatus = v)),
              if (_vaccinationStatus == 'Vaccinated')
                _dateRow('Date Last Vaccination', _dateLastVaccination, (d) => setState(() => _dateLastVaccination = d)),
              _dropdownField('Contact with Confirmed Case', _contactWithConfirmedCase, _yesNoUnknown, (v) => setState(() => _contactWithConfirmedCase = v)),
              _dropdownField('Recent Travel History', _recentTravelHistory, _travelHistoryOptions, (v) => setState(() => _recentTravelHistory = v)),
              if (_recentTravelHistory == 'Yes')
                _textField('Travel Destination', _travelDestinationController),

              _sectionTitle('Reporter Information'),
              _textField('Reporter Name', _reporterNameController),
              _textField('Designation', _designationController),
              _textField('Contact Number', _contactNumberController),
              _dateRow('Date Reported', _dateReported, (d) => setState(() => _dateReported = d)),
              _textField('Form Completed By', _formCompletedByController),
              _dateRow('Date Form Completed', _dateFormCompleted, (d) => setState(() => _dateFormCompleted = d)),
              _textField('Health Facility Code', _healthFacilityCodeController),
              _textField('District Code', _districtCodeController),
              _textField('Form Version', _formVersionController),
              _textField('Observations', _observationsController),

              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
   