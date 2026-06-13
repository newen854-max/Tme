import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(const TechnomakHseApp());
}

class TechnomakHseApp extends StatelessWidget {
  const TechnomakHseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technomak HSE Incident Management',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[50],
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IncidentActionItem {
  final int sNo;
  final String incidentNumber;
  final String rootCause;
  final String correctiveAction;
  final String targetDate;
  final String responsiblePerson;
  final String status;

  IncidentActionItem({
    required this.sNo,
    required this.incidentNumber,
    required this.rootCause,
    required this.correctiveAction,
    required this.targetDate,
    required this.responsiblePerson,
    required this.status,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<IncidentActionItem> _mockRegister = [
    IncidentActionItem(
      sNo: 1,
      incidentNumber: "TMAK-2026-001",
      rootCause: "2. Failure to follow rules/procedures",
      correctiveAction: "Conduct mandatory tool-box talk refreshers for height work.",
      targetDate: "2026-06-10",
      responsiblePerson: "John Doe",
      status: "Overdue",
    ),
    IncidentActionItem(
      sNo: 2,
      incidentNumber: "TMAK-2026-002",
      rootCause: "5. Inadequate PPE",
      correctiveAction: "Procure and distribute specialized chemical handling gloves.",
      targetDate: "2026-06-25",
      responsiblePerson: "Ahmed Ali",
      status: "Pending",
    ),
    IncidentActionItem(
      sNo: 3,
      incidentNumber: "TMAK-2026-003",
      rootCause: "12. Lack of or poor housekeeping",
      correctiveAction: "Clear workspace debris from main scaffolding zone walkways.",
      targetDate: "2026-05-14",
      responsiblePerson: "Rasool Ghulam",
      status: "Completed",
    ),
  ];

  final _incidentNumCtrl = TextEditingController(text: "TMAK-2026-004");
  final _reportDateCtrl = TextEditingController(text: "2026-06-14");
  final _detailsCtrl = TextEditingController();
  final _additionalInfoCtrl = TextEditingController();
  final _recoveryCtrl = TextEditingController();
  final _learningPointCtrl = TextEditingController();

  String? _selectedDirectCause;
  String? _selectedRootCause;
  String? _selectedBodyPart;
  String? _selectedNatureInjury;
  String? _selectedTypeIncident;

  bool _revisionRequired = false;

  String _logoName = "Not Uploaded (Using Default)";
  String _attachmentName = "No files attached";
  String _witnessStatementName = "No files uploaded";

  final SignatureController _supervisorSig = SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  final SignatureController _managerSig = SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  final SignatureController _hseTeamSig = SignatureController(penStrokeWidth: 3, penColor: Colors.black);

  final List<String> _causes1to32 = List.generate(32, (index) {
    const labels = [
      "Lack of communication – info error/omission", "Failure to follow rules/procedures",
      "Inadequate warning/safety devices", "Failure to observe/use warning devices",
      "Inadequate PPE", "Improper manual/mechanical handling", "Incorrect material stacking",
      "Inadequate equipment/tools", "Misuse of equipment/tools", "Inadequate maintenance/inspection",
      "Work environment factors", "Lack of or poor housekeeping", "Failure to secure loose/falling objects",
      "Access/egress", "External factors", "Operating without authority", "Deliberate violation",
      "Workplace distractions/horseplay", "Influence of intoxicants", "Overloading of material/equipment",
      "Inadequate supervision", "Engineering design/specifications", "Inadequate policies & procedures",
      "Work practices, standards & methods", "Planning and organization", "Hazard recognition/perception",
      "Managerial practices", "Inadequate knowledge/skills", "Inadequate motivation", "Excessive stress",
      "Contract conditions and controls", "Poor/inadequate intervention culture"
    ];
    return "${index + 1}. ${labels[index]}";
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        if (type == 'logo') _logoName = result.files.single.name;
        if (type == 'attach') _attachmentName = result.files.single.name;
        if (type == 'witness') _witnessStatementName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TECHNOMAK HSE SYSTEM", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFC62828),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "Home Dashboard"),
            Tab(text: "Incident Register"),
            Tab(text: "1. Info & Details"),
            Tab(text: "2. Appendix F Analysis"),
            Tab(text: "3. Corrective Actions"),
            Tab(text: "4. Approvals"),
            Tab(text: "5. Upload Media"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildRegisterTab(),
          _buildInfoDetailsTab(),
          _buildAppendixFTab(),
          _buildCorrectiveActionsTab(),
          _buildApprovalsTab(),
          _buildUploadMediaTab(),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Executive HSE Safety Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildKpiCard("Total Incidents", "3", Colors.blue),
              _buildKpiCard("Pending Actions", "1", Colors.amber),
              _buildKpiCard("Overdue Critical", "1", Colors.red),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Incident Root Cause Contribution Matrix", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5,
                barGroups: [
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 3, color: Colors.red, width: 25)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 1, color: Colors.orange, width: 25)]),
                  BarChartGroupData(x: 12, barRods: [BarChartRodData(toY: 2, color: Colors.blue, width: 25)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(count, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: const [
                DataColumn(label: Text('S.No')),
                DataColumn(label: Text('Incident Number')),
                DataColumn(label: Text('Root Cause Description')),
                DataColumn(label: Text('Corrective Action Matrix')),
                DataColumn(label: Text('Target Date')),
                DataColumn(label: Text('Responsible Person')),
                DataColumn(label: Text('Status Block')),
              ],
              rows: _mockRegister.map((item) {
                Color statusColor = Colors.green;
                if (item.status == "Overdue") statusColor = Colors.red;
                if (item.status == "Pending") statusColor = Colors.orange;

                return DataRow(
                  cells: [
                    DataCell(Text(item.sNo.toString())),
                    DataCell(Text(item.incidentNumber)),
                    DataCell(SizedBox(width: 200, child: Text(item.rootCause, overflow: TextOverflow.ellipsis))),
                    DataCell(SizedBox(width: 250, child: Text(item.correctiveAction, overflow: TextOverflow.ellipsis))),
                    DataCell(Text(item.targetDate)),
                    DataCell(Text(item.responsiblePerson)),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
                      child: Text(item.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("FINAL INVESTIGATION REPORT METADATA"),
          Row(
            children: [
              Expanded(child: TextFormField(controller: _incidentNumCtrl, decoration: const InputDecoration(labelText: "Incident Reference Number *"))),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _reportDateCtrl, decoration: const InputDecoration(labelText: "Date of Report *"))),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("INCIDENT CHRONOLOGY & TIMELINE"),
          TextFormField(controller: _detailsCtrl, maxLines: 4, decoration: const InputDecoration(labelText: "Details of Incident *")),
          const SizedBox(height: 16),
          TextFormField(controller: _additionalInfoCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Other/Additional Information")),
          const SizedBox(height: 16),
          TextFormField(controller: _recoveryCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Immediate Recovery Measure Applied *")),
        ],
      ),
    );
  }

  Widget _buildAppendixFTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("APPENDIX F - INCIDENT INVESTIGATION REPORT GUIDELINES"),
          _buildDropdownField("Direct Cause of the Incident *", _selectedDirectCause, _causes1to32, (val) => setState(() => _selectedDirectCause = val)),
          const SizedBox(height: 16),
          _buildDropdownField("Root Cause of the Incident *", _selectedRootCause, _causes1to32, (val) => setState(() => _selectedRootCause = val)),
          const SizedBox(height: 20),
          _buildSectionHeader("BIOMETRIC INJURY CLASSIFICATION PROFILE"),
          _buildDropdownField("Body Part Injured *", _selectedBodyPart, [
            "1. Foot / Toe / Ankle / Knee", "2. Eye (Left / Right)", "3. Back", 
            "4. Hand / Finger", "5. Hand/Arm / Shoulder", "6. Body / Trunk", "7. Face", "8. Head", "9. Abdomen", "10. Others"
          ], (val) => setState(() => _selectedBodyPart = val)),
          const SizedBox(height: 16),
          _buildDropdownField("Nature of Injury *", _selectedNatureInjury, [
            "1. Fracture", "2. Bruise / laceration", "3. Burn / Scald", "4. Sprain", "5. Cut / Amputation", "6. Electric Shock", "7. Foreign Body", "8. Crush", "9. Heat Stroke", "10. Others"
          ], (val) => setState(() => _selectedNatureInjury = val)),
          const SizedBox(height: 16),
          _buildDropdownField("Type of Incident *", _selectedTypeIncident, [
            "1. Striking against", "2. Struck by", "3. Caught in between", "4. Contact with", "5. Fall/slip/trip", "6. Lifting/pulling", "7. Explosion/burns", "8. Others"
          ], (val) => setState(() => _selectedTypeIncident = val)),
        ],
      ),
    );
  }

  Widget _buildCorrectiveActionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("KNOWLEDGE MANAGEMENT & LESSONS LEARNED"),
          TextFormField(controller: _learningPointCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Learning Point")),
          const SizedBox(height: 24),
          _buildSectionHeader("CORRECTIVE / PREVENTIVE MEASURES MATRIX TRACKING"),
          Table(
            border: TableBorder.all(color: Colors.grey.shade400),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: const [
                  Padding(padding: EdgeInsets.all(8), child: Text("Corrective Measure Plan", style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text("Actionee (Resp)", style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text("Target Date", style: TextStyle(fontWeight: FontWeight.bold))),
                ]
              ),
              const TableRow(
                children: [
                  Padding(padding: EdgeInsets.all(8), child: Text("Conduct physical safety verification clearance")),
                  Padding(padding: EdgeInsets.all(8), child: Text("Rasool Ghulam")),
                  Padding(padding: EdgeInsets.all(8), child: Text("2026-06-30")),
                ]
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("INCIDENT SIGN-OFF VALIDATION PIPELINE"),
          _buildSignatureBox("Line Supervisor Verification Signature Panel", _supervisorSig),
          _buildSignatureBox("Line Manager Strategy Review Panel", _managerSig),
          _buildSignatureBox("HSE Team Compliance System Validation Signature", _hseTeamSig),
          const SizedBox(height: 16),
          Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text("REGULATORY COMPLIANCE SYSTEM REQUIREMENT EVALUATION", style: TextStyle(fontWeight: FontWeight.bold)),
                  SwitchListTile(
                    title: const Text("Any revision of existing documents required?"),
                    value: _revisionRequired,
                    onChanged: (val) => setState(() => _revisionRequired = val),
                    activeColor: const Color(0xFFC62828),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUploadMediaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("SYSTEM LOGO BRANDING PLATFORM CONFIGURATION"),
          ListTile(
            leading: const Icon(Icons.business, color: Colors.blue),
            title: const Text("Upload Corporate Identity Logo Asset"),
            subtitle: Text(_logoName),
            trailing: ElevatedButton(onPressed: () => _pickFile('logo'), child: const Text("Browse")),
          ),
          const Divider(),
          _buildSectionHeader("DOCUMENT MANAGEMENT INFRASTRUCTURE CENTER"),
          ListTile(
            leading: const Icon(Icons.attach_file, color: Colors.green),
            title: const Text("General Field Attachments"),
            subtitle: Text(_attachmentName),
            trailing: ElevatedButton(onPressed: () => _pickFile('attach'), child: const Text("Upload")),
          ),
          ListTile(
            leading: const Icon(Icons.gavel, color: Colors.deepPurple),
            title: const Text("Formal Verification Witness Statement Upload"),
            subtitle: Text(_witnessStatementName),
            trailing: ElevatedButton(onPressed: () => _pickFile('witness'), child: const Text("Upload")),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFC62828))),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: selectedValue,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _buildSignatureBox(String label, SignatureController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          color: Colors.grey[200],
          child: Signature(controller: controller, height: 100, backgroundColor: Colors.white),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () => controller.clear(), child: const Text("Clear Pad", style: TextStyle(color: Colors.red))),
        )
      ],
    );
  }
}
