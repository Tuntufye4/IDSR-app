import 'package:flutter/material.dart';
import '/models/idsr_case.dart';
import '/api/idsr_api.dart';
import '../components/dropdown_options.dart';

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
  final _nationalIdController = TextEditingController();
  final _villageController = TextEditingController();
  final _taController = TextEditingController();
  final _labNameController = TextEditingController();
  final _reporterNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _formCompletedByController = TextEditingController();
  final _formVersionController = TextEditingController();
  final _observationsController = TextEditingController();
  final _travelDestinationController = TextEditingController();

  // Dropdowns
  String? _sex,
      _disease,
      _caseClassification,
      _outcome,
      _specimenCollected,
      _specimenSentToLab,
      _labResult,
      _finalCaseClassification,
      _vaccinationStatus,
      _contactWithConfirmedCase,
      _recentTravelHistory,
      _designation,
      _diagnosisType,
      _district,
      _districtCode,
      _healthFacility,
      _healthFacilityCode,
      _region,
      _specimenType;

  int? _age, _reportingWeekNumber, _year;

  // Dates
  DateTime? _dob,
      _dateOnset,
      _dateFirstSeen,
      _dateOfDeath,
      _dateSpecimenCollected,
      _dateResultReceived,
      _dateLastVaccination,
      _dateReported,
      _dateFormCompleted;

  // Section expanded states
  bool _patientInfoExpanded = true,
      _clinicalInfoExpanded = true,
      _specimenLabInfoExpanded = true,
      _vaccinationContactExpanded = true,
      _reporterInfoExpanded = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalIdController.dispose();
    _villageController.dispose();
    _taController.dispose();
    _labNameController.dispose();
    _reporterNameController.dispose();
    _contactNumberController.dispose();
    _formCompletedByController.dispose();
    _formVersionController.dispose();
    _observationsController.dispose();
    _travelDestinationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(String label, DateTime? value, void Function(DateTime) onPicked) async {
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
          child: Text(value == null ? '$label not set' : '$label: ${value.toIso8601String().split("T")[0]}'),
        ),
        TextButton(
          onPressed: () => _pickDate(label, value, onPick),
          child: const Text('Pick Date'),
        ),
      ],
    );
  }

  Widget _dropdownField<T>(String label, T? value, List<T> options, void Function(T?) onChanged) {
    return DropdownButtonFormField<T?>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: value,
      items: options.map((o) => DropdownMenuItem<T?>(
        value: o,
        child: Text(o.toString()),
      )).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Required' : null,
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final caseData = IdsrCase(
      fullName: _fullNameController.text,
      age: _age,
      sex: _sex,
      dateOfBirth: _dob,
      nationalId: _nationalIdController.text,
      village: _villageController.text,
      traditionalAuthority: _taController.text,
      healthFacility: _healthFacility,
      district: _district,
      region: _region,
      dateOnsetSymptoms: _dateOnset,
      dateFirstSeen: _dateFirstSeen,
      disease: _disease,
      caseClassification: _caseClassification,
      outcome: _outcome,
      dateOfDeath: _dateOfDeath,
      diagnosisType: _diagnosisType,
      specimenCollected: _specimenCollected,
      dateSpecimenCollected: _dateSpecimenCollected,
      specimenType: _specimenType,
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
      designation: _designation,
      contactNumber: _contactNumberController.text,
      dateReported: _dateReported,
      formCompletedBy: _formCompletedByController.text,
      dateFormCompleted: _dateFormCompleted,
      reportingWeekNumber: _reportingWeekNumber,
      year: _year,
      healthFacilityCode: _healthFacilityCode,
      districtCode: _districtCode,
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
    _nationalIdController.clear();
    _villageController.clear();
    _taController.clear();
    _labNameController.clear();
    _reporterNameController.clear();
    _contactNumberController.clear();
    _formCompletedByController.clear();
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
      _designation = null;
      _diagnosisType = null;
      _district = null;
      _districtCode = null;
      _healthFacility = null;
      _healthFacilityCode = null;
      _region = null;
      _specimenType = null;
      _age = null;
      _reportingWeekNumber = null;
      _year = null;
      _dob = null;
      _dateOnset = null;
      _dateFirstSeen = null;
      _dateOfDeath = null;
      _dateSpecimenCollected = null;
      _dateResultReceived = null;
      _dateLastVaccination = null;
      _dateReported = null;
      _dateFormCompleted = null;

      _patientInfoExpanded = true;
      _clinicalInfoExpanded = true;
      _specimenLabInfoExpanded = true;
      _vaccinationContactExpanded = true;
      _reporterInfoExpanded = true;
    });
  }

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
              // Patient Info
              ExpansionTile(
                initiallyExpanded: _patientInfoExpanded,
                title: const Text('Patient Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _textField('Full Name', _fullNameController),
                  const SizedBox(height: 10),
                  _dropdownField('Age', _age, List<int>.generate(121, (i) => i), (v) => setState(() => _age = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Sex', _sex, ['Male', 'Female'], (v) => setState(() => _sex = v)),
                  const SizedBox(height: 10),
                  _textField('National ID', _nationalIdController),
                  const SizedBox(height: 10),
                  _textField('Village', _villageController),
                  const SizedBox(height: 10),
                  _textField('Traditional Authority', _taController),
                  const SizedBox(height: 10),
                  _dropdownField('Health Facility', _healthFacility, healthFacilityOptions, (v) => setState(() => _healthFacility = v)),
                  const SizedBox(height: 10),
                  _dropdownField('District', _district, districts, (v) => setState(() => _district = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Region', _region, regions, (v) => setState(() => _region = v)),
                  const SizedBox(height: 10),
                  _dateRow('Date of Birth', _dob, (d) => setState(() => _dob = d)),
                ],
              ),

              // Clinical Info
              ExpansionTile(
                initiallyExpanded: _clinicalInfoExpanded,
                title: const Text('Clinical Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _dateRow('Date of Onset Symptoms', _dateOnset, (d) => setState(() => _dateOnset = d)),
                  const SizedBox(height: 10),
                  _dateRow('Date First Seen', _dateFirstSeen, (d) => setState(() => _dateFirstSeen = d)),
                  const SizedBox(height: 10),
                  _dropdownField('Disease', _disease, diseases, (v) => setState(() => _disease = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Case Classification', _caseClassification, caseClassifications, (v) => setState(() => _caseClassification = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Outcome', _outcome, outcomes, (v) => setState(() => _outcome = v)),
                  if (_outcome == 'Deceased')
                    _dateRow('Date of Death', _dateOfDeath, (d) => setState(() => _dateOfDeath = d)),
                  const SizedBox(height: 10),
                  _dropdownField('Diagnosis Type', _diagnosisType, diagnosisTypes, (v) => setState(() => _diagnosisType = v)),
                ],
              ),

              // Specimen & Lab Info
              ExpansionTile(
                initiallyExpanded: _specimenLabInfoExpanded,
                title: const Text('Specimen & Lab Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _dropdownField('Specimen Collected', _specimenCollected, yesNoUnknown, (v) => setState(() => _specimenCollected = v)),
                  if (_specimenCollected == 'Yes') ...[
                    _dateRow('Date Specimen Collected', _dateSpecimenCollected, (d) => setState(() => _dateSpecimenCollected = d)),
                    const SizedBox(height: 10),
                    _dropdownField('Specimen Type', _specimenType, specimenTypeOptions, (v) => setState(() => _specimenType = v)),
                  ],
                  const SizedBox(height: 10),
                  _dropdownField('Specimen Sent to Lab', _specimenSentToLab, yesNoUnknown, (v) => setState(() => _specimenSentToLab = v)),
                  if (_specimenSentToLab == 'Yes') ...[
                    _textField('Lab Name', _labNameController),
                    const SizedBox(height: 10),
                    _dropdownField('Lab Result', _labResult, labResults, (v) => setState(() => _labResult = v)),
                    const SizedBox(height: 10),
                    _dateRow('Date Result Received', _dateResultReceived, (d) => setState(() => _dateResultReceived = d)),
                  ],
                  const SizedBox(height: 10),
                  _dropdownField('Final Case Classification', _finalCaseClassification, finalClassifications, (v) => setState(() => _finalCaseClassification = v)),
                ],
              ),

              // Vaccination & Contact
              ExpansionTile(
                initiallyExpanded: _vaccinationContactExpanded,
                title: const Text('Vaccination & Contact History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _dropdownField('Vaccination Status', _vaccinationStatus, vaccinationStatusList, (v) => setState(() => _vaccinationStatus = v)),
                  if (_vaccinationStatus == 'Vaccinated')
                    _dateRow('Date Last Vaccination', _dateLastVaccination, (d) => setState(() => _dateLastVaccination = d)),
                  const SizedBox(height: 10),
                  _dropdownField('Contact with Confirmed Case', _contactWithConfirmedCase, yesNoUnknown, (v) => setState(() => _contactWithConfirmedCase = v)),
                  const SizedBox(height: 10),
                  _dropdownField('Recent Travel History', _recentTravelHistory, travelHistoryOptions, (v) => setState(() => _recentTravelHistory = v)),
                  if (_recentTravelHistory == 'Yes')
                    _textField('Travel Destination', _travelDestinationController),
                ],
              ),

              // Reporter Info
              ExpansionTile(
                initiallyExpanded: _reporterInfoExpanded,
                title: const Text('Reporter Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  _textField('Reporter Name', _reporterNameController),
                  const SizedBox(height: 10),
                  _dropdownField('Designation', _designation, designationOptions, (v) => setState(() => _designation = v)),
                  const SizedBox(height: 10),
                  _textField('Contact Number', _contactNumberController),
                  const SizedBox(height: 10),
                  _dateRow('Date Reported', _dateReported, (d) => setState(() => _dateReported = d)),
                  const SizedBox(height: 10),
                  _textField('Form Completed By', _formCompletedByController),
                  const SizedBox(height: 10),
                  _dateRow('Date Form Completed', _dateFormCompleted, (d) => setState(() => _dateFormCompleted = d)),
                  const SizedBox(height: 10),
                  _dropdownField('Health Facility Code', _healthFacilityCode, healthFacilityCodes, (v) => setState(() => _healthFacilityCode = v)),
                  const SizedBox(height: 10),
                  _dropdownField('District Code', _districtCode, districtCodes, (v) => setState(() => _districtCode = v)),
                  const SizedBox(height: 10),
                  _textField('Form Version', _formVersionController),
                  const SizedBox(height: 10),
                  _textField('Observations', _observationsController),
                  const SizedBox(height: 10),
                  _dropdownField('Reporting Week Number', _reportingWeekNumber, weekNumbers, (v) => setState(() => _reportingWeekNumber = v as int?)),
                  const SizedBox(height: 10),
                  _dropdownField('Year', _year, yearOptions, (v) => setState(() => _year = v as int?)),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: _submitForm, child: const Text('Submit'))),
                  const SizedBox(width: 10),
                  Expanded(child: OutlinedButton(onPressed: _clearForm, child: const Text('Clear'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
   