import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(const TechnomakHseApp());
}

class TechnomakHseApp extends StatelessWidget {
  const TechnomakHseApp({Key? key}) : constructor(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technomak HSE Incident Management',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFC62828), // Professional Industrial Red
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

// Global Model for Incident Tracking
class IncidentActionItem {
  final int sNo;
  final String incidentNumber;
  final String rootCause;
  final String correctiveAction;
  final String targetDate;
  final String responsiblePerson;
  final String status; // Pending, Overdue, Completed

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

  // Mock Data for Register and Dashboard Analysis
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
      correctiveAction: "Clear workspace debris from main scaffolding zone access walkways.",
      targetDate: "2026-05-14",
      responsiblePerson: "Rasool Ghulam",
      status: "Completed",
    ),
  ];

  // Form Field State Controllers & Variables
  final _incidentNumCtrl = TextEditingController(text: "TMAK-2026-004");
  final _reportDateCtrl = TextEditingController(text: "2026-06-14");
  final _detailsCtrl = TextEditingController();
  final _additionalInfoCtrl = TextEditingController();
  final _recoveryCtrl = TextEditingController();
  final _learningPointCtrl = TextEditingController();

  // Appendix F Selections
  String? _selectedDirectCause;
  String? _selectedRootCause;
  String? _selectedBodyPart;
  String? _selectedNatureInjury;
  String? _selectedTypeIncident;

  String _otherBodyPart = "";
  String _otherNatureInjury = "";
  String _otherTypeIncident = "";

  bool _revisionRequired = false;

  // File Name Trackers
  String _logoName = "Not Uploaded (Using Default)";
  String _attachmentName = "No files attached";
  String _witnessStatementName = "No files uploaded";

  // Signature Controllers
  final SignatureController _supervisorSig = SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  final SignatureController _managerSig = SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  final SignatureController _hseTeamSig = SignatureController(penStrokeWidth: 3, penColor: Colors.black);

  // Lists for Appendix F Menus
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

  // File Picker Helpers
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              color: Colors.white,
              child: const Icon(Icons.gavel, color: Color(0xFFC62828)),
            ),
            const SizedBox(width: 10),
            const Text("TECHNOMAK HSE SYSTEM", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        backgroundColor: const Color(0xFFC62828),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: "Home Dashboard"),
            Tab(icon: Icon(Icons.assignment), text: "Incident Register"),
            Tab(icon: Icon(Icons.info), text: "1. Info & Details"),
            Tab(icon: Icon(Icons.analytics), text: "2. Appendix F Analysis"),
            Tab(icon: Icon(Icons.build), text: "3. Corrective Actions"),
            Tab(icon: Icon(Icons.verified_user), text: "4. Approvals"),
            Tab(icon: Icon(Icons.cloud_upload), text: "5. Upload Media"),
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
      bottomNavigationBar: _buildDocumentControlFooter(),
    );
  }

  // --- TAB 1: HOME DASHBOARD ---
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
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),
          const Center(child: Text("X-Axis: Appendix F Item References (Items #2, #5, #12)", style: TextStyle(fontSize: 12, color: Colors.grey))),
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

  // --- TAB 2: INTERACTIVE DATA REGISTER ---
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
                DataColumn(label: Text('S.No', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Incident Number', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Root Cause Description', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Corrective Action Matrix', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Target Date', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Responsible Person', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status Block', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: _mockRegister.map((item) {
                Color statusColor = Colors.green;
                if (item.status == "Overdue") statusColor = Colors.red;
                if (item.status == "Pending") statusColor = Colors.orange;

                return DataRow(
                  backgroundColor: item.status == "Overdue" ? MaterialStateProperty.all(Colors.red.withOpacity(0.08)) : null,
                  cells: [
                    DataCell(Text(item.sNo.toString())),
                    DataCell(Text(item.incidentNumber)),
                    DataCell(SizedBox(width: 200, child: Text(item.rootCause, overflow: TextOverflow.ellipsis))),
                    DataCell(SizedBox(width: 250, child: Text(item.correctiveAction, overflow: TextOverflow.ellipsis))),
                    DataCell(Text(item.targetDate)),
                    DataCell(Text(item.responsiblePerson)),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, py: 4),
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

  // --- TAB 3: WIZARD STEP 1 - INFO & DETAILS ---
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
          TextFormField(controller: _detailsCtrl, maxLines: 4, decoration: const InputDecoration(labelText: "Details of Incident *", hintText: "Provide chronological workflow series detailing operational disruption")),
          const SizedBox(height: 16),
          TextFormField(controller: _additionalInfoCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Other/Additional Information", hintText: "Weather parameters, Training protocols undergone, TBT system logs, etc.")),
          const SizedBox(height: 16),
          TextFormField(controller: _recoveryCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Immediate Recovery Measure Applied *", hintText: "Immediate structural triage mitigation details")),
        ],
      ),
    );
  }

  // --- TAB 4: WIZARD STEP 2 - APPENDIX F ANALYSIS ---
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
            "1. Foot / Toe / Ankle / Knee (Left / Right)", "2. Eye (Left / Right)", "3. Back", 
            "4. Hand / Finger (Left / Right)", "5. Hand/Arm / Shoulder (Left / Right)", 
            "6. Body / Trunk", "7. Face", "8. Head", "9. Abdomen", "10. Others (Specify)"
          ], (val) => setState(() => _selectedBodyPart = val)),
          if (_selectedBodyPart?.contains("10. Others") ?? false) ...[
            const SizedBox(height: 8),
            TextFormField(onChanged: (val) => _otherBodyPart = val, decoration: const InputDecoration(labelText: "Specify Body Part Parameters")),
          ],

          const SizedBox(height: 16),
          _buildDropdownField("Nature of Injury *", [
            "1. Fracture", "2. Bruise / laceration /abrasion /puncture/ contusion", "3. Burn / Scald",
            "4. Stretched or twisted / Sprain", "5. Cut / Incision / Amputation", "6. Electric Shock",
            "7. Foreign Body", "8. Crush", "9. Heat Stroke", "10. Others (Specify)"
          ], _selectedNatureInjury, (val) => setState(() => _selectedNatureInjury = val)),
          if (_selectedNatureInjury?.contains("10. Others") ?? false) ...[
            const SizedBox(height: 8),
            TextFormField(onChanged: (val) => _otherNatureInjury = val, decoration: const InputDecoration(labelText: "Specify Nature Parameters")),
          ],

          const SizedBox(height: 16),
          _buildDropdownField("Type of Incident *", [
            "1. Striking against", "2. Struck by (falling , sliding or moving / flying object)",
            "3. Struck in / caught in between/ compressed by", "4. Contact with (electricity / temp / chemical/radiation etc.)",
            "5. Fall/slip/trip on same level or to lower level", "6. Lifting/pulling/pushing",
            "7. Explosion/burns", "8. Others (Specify)"
          ], _selectedTypeIncident, (val) => setState(() => _selectedTypeIncident = val)),
          if (_selectedTypeIncident?.contains("8. Others") ?? false) ...[
            const SizedBox(height: 8),
            TextFormField(onChanged: (val) => _otherTypeIncident = val, decoration: const InputDecoration(labelText: "Specify Incident Variant Type")),
          ],
        ],
      ),
    );
  }

  // --- TAB 5: WIZARD STEP 3 - CORRECTIVE ACTIONS ---
  Widget _buildCorrectiveActionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("KNOWLEDGE MANAGEMENT & LESSONS LEARNED"),
          TextFormField(controller: _learningPointCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Learning Point", hintText: "Strategic systemic engineering take-away observations")),
          const SizedBox(height: 24),
          _buildSectionHeader("CORRECTIVE / PREVENTIVE MEASURES MATRIX TRACKING"),
          Table(
            border: TableBorder.all(color: Colors.grey.shade400),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                backgroundColor: Colors.grey[200],
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

  // --- TAB 6: WIZARD STEP 4 - APPROVAL SIGN-OFFS ---
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
                    title: const Text("Any revision of existing documents (TRA/ Procedures) based on this incident outcome required?"),
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

  // --- TAB 7: WIZARD STEP 5 - MEDIA UPLOADS ---
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
            title: const Text("General Field Attachments (Statements, Drawings, Photos)"),
            subtitle: Text(_attachmentName),
            trailing: ElevatedButton(onPressed: () => _pickFile('attach'), child: const Text("Upload")),
          ),
          ListTile(
            leading: const Icon(Icons.gavel, color: Colors.deepPurple),
            title: const Text("Formal Verification Witness Statement Upload"),
            subtitle: Text(_witnessStatementName),
            trailing: ElevatedButton(onPressed: () => _pickFile('witness'), child: const Text("Upload")),
          ),
          const SizedBox(height: 20),
          const Text("Attach photos if any", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          Container(
            height: 100,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), color: Colors.grey[100]),
            child: const Center(child: Text("Interactive Photo File Previews Live Display Zone")),
          )
        ],
      ),
    );
  }

  // --- UTILITY COMPONENT CREATORS ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFC62828), letterSpacing: 0.5)),
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
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          color: Colors.grey[200],
          child: Signature(controller: controller, height: 100, backgroundColor: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () => controller.clear(), child: const Text("Clear Pad", style: TextStyle(color: Colors.red))),
          ],
        )
      ],
    );
  }

  Widget _buildDocumentControlFooter() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade300))),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.between,
        children: const [
          Text("Ref.: TMAK-HSE-F 019", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text("Rev. No: 03", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text("Date: 21.08.2014", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}
