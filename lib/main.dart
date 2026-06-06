import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/health.dart';
import 'dart:async';

void main() => runApp(const TradeHealthApp());

class TradeHealthApp extends StatelessWidget {
  const TradeHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trader Health',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFFF9A825),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF9A825),
          secondary: Color(0xFFF9A825),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}

// ==================== مدل‌های داده ====================
class Challenge {
  String id;
  String title;
  String description;
  int points;
  bool isCompleted;
  DateTime date;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.isCompleted = false,
    required this.date,
  });
}

class TraderComparison {
  int userSteps;
  int avgSteps;
  int userSleep;
  int avgSleep;
  int userStress;
  int avgStress;
  bool userJournal;
  double journalPercentage;

  TraderComparison({
    this.userSteps = 0,
    this.avgSteps = 7500,
    this.userSleep = 0,
    this.avgSleep = 7,
    this.userStress = 0,
    this.avgStress = 5,
    this.userJournal = false,
    this.journalPercentage = 65,
  });
}

// ==================== صفحه احراز هویت ====================
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  String? _selectedRole;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF9A825), Color(0xFF0A0E21)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.monitor_heart,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  _isLogin ? 'ورود به حساب' : 'ثبت‌نام جدید',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                if (!_isLogin) ...[
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'نام و نام خانوادگی',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextField(
                  controller: _emailController,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'ایمیل',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  style: const TextStyle(fontSize: 16),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'رمز عبور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (!_isLogin) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        hint: const Text('شما تریدر هستید یا خانواده تریدر؟'),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: const [
                          DropdownMenuItem(
                            value: 'trader',
                            child: Row(
                              children: [
                                Icon(Icons.trending_up, color: Colors.green),
                                SizedBox(width: 10),
                                Text('🟢 تریدر'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'family',
                            child: Row(
                              children: [
                                Icon(Icons.family_restroom, color: Colors.orange),
                                SizedBox(width: 10),
                                Text('🟠 خانواده تریدر'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                ElevatedButton(
                  onPressed: _handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9A825),
                    foregroundColor: const Color(0xFF0A0E21),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _isLogin ? 'ورود' : 'ثبت‌نام',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'حساب کاربری نداری؟' : 'حساب کاربری داری؟',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          if (!_isLogin) _selectedRole = null;
                        });
                      },
                      child: Text(
                        _isLogin ? 'ثبت‌نام' : 'ورود',
                        style: const TextStyle(
                          color: Color(0xFFF9A825),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAuth() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackbar('لطفا ایمیل و رمز عبور را وارد کن');
      return;
    }

    if (!_isLogin && _nameController.text.isEmpty) {
      _showSnackbar('لطفا نام خود را وارد کن');
      return;
    }

    if (!_isLogin && _selectedRole == null) {
      _showSnackbar('لطفا نقش خود را انتخاب کن');
      return;
    }

    _showSnackbar('ورود موفق! خوش اومدی');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

// ==================== صفحه اصلی با سایدبار ====================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HealthDashboard(),
    const DailyChallengesPage(),
    const MeditationPage(),
    const ComparisonPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TraderHealth'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0A0E21),
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0E21),
        selectedItemColor: const Color(0xFFF9A825),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'داشبورد'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'چالش'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'مدیتیشن'),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: 'مقایسه'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'تنظیمات'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF0A0E21),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9A825), Color(0xFF0A0E21)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFF0A0E21)),
                  ),
                  const SizedBox(height: 10),
                  const Text('کاربر گرامی', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Text('تریدر حرفه‌ای', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'داشبورد سلامت', 0),
            _buildDrawerItem(Icons.emoji_events, 'چالش‌های روزانه', 1),
            _buildDrawerItem(Icons.self_improvement, 'مدیتیشن', 2),
            _buildDrawerItem(Icons.compare_arrows, 'مقایسه با تریدرها', 3),
            _buildDrawerItem(Icons.settings, 'تنظیمات', 4),
            const Divider(color: Colors.grey),
            _buildDrawerItem(Icons.logout, 'خروج', null, isRed: true, onTap: _logout),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int? index, {bool isRed = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.red : const Color(0xFFF9A825)),
      title: Text(title, style: TextStyle(color: isRed ? Colors.red : Colors.white)),
      onTap: onTap ?? (() {
        setState(() => _selectedIndex = index!);
        Navigator.pop(context);
      }),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0E21),
        title: const Text('خروج از حساب'),
        content: const Text('آیا مطمئنی میخوای خارج بشی؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage()));
            },
            child: const Text('خروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ==================== صفحه داشبورد سلامت با Health واقعی ====================
class HealthDashboard extends StatefulWidget {
  const HealthDashboard({super.key});

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  final HealthFactory _health = HealthFactory();
  bool _isLoading = true;
  bool _hasPermission = false;

  // دیتای واقعی
  int _steps = 0;
  int _heartRate = 0;
  double _sleepHours = 0;
  int _stressLevel = 5;

  @override
  void initState() {
    super.initState();
    _initHealth();
  }

  Future<void> _initHealth() async {
    try {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_ASLEEP,
      ];
      final permissions = [
        HealthDataAccess.READ,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
      ];

      final granted = await _health.requestAuthorization(types, permissions: permissions);

      if (granted) {
        _hasPermission = true;
        await _fetchAllHealthData();
      }
    } catch (e) {
      print('Error initializing Health: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchAllHealthData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterdayStart = DateTime(now.year, now.month, now.day - 1);

    try {
      final stepsData = await _health.getHealthDataFromTypes(today, now, [HealthDataType.STEPS]);
      _steps = stepsData.fold<int>(0, (sum, point) => sum + point.value.toInt());

      final heartRateData = await _health.getHealthDataFromTypes(today, now, [HealthDataType.HEART_RATE]);
      if (heartRateData.isNotEmpty) {
        double avg = heartRateData.fold<double>(0, (sum, point) => sum + point.value) / heartRateData.length;
        _heartRate = avg.round();
      }

      final sleepData = await _health.getHealthDataFromTypes(yesterdayStart, today, [HealthDataType.SLEEP_ASLEEP]);
      int sleepSeconds = sleepData.fold<int>(0, (sum, point) => sum + point.value.toInt());
      _sleepHours = sleepSeconds / 3600;

      setState(() {});
    } catch (e) {
      print('Error fetching health data: $e');
    }
  }

  void _refreshData() {
    setState(() => _isLoading = true);
    _fetchAllHealthData().then((_) {
      setState(() => _isLoading = false);
    });
  }

  String getTradingAdvice() {
    if (_sleepHours < 5) return "⛔ خواب کافی نداشتی، امروز معامله نکن!";
    if (_stressLevel > 7) return "⚠️ استرس بالاست، حواست به تصمیمات احساسی باشه";
    if (_sleepHours >= 7 && _stressLevel <= 3) return "✅ وضعیت عالی، آماده معاملات پر بازده";
    return "⚠️ مراقب باش، شرایط متوسط هست";
  }

  Color getAdviceColor() {
    if (_sleepHours < 5 || _stressLevel > 7) return Colors.red;
    if (_sleepHours >= 7 && _stressLevel <= 3) return Colors.green;
    return Colors.orange;
  }

  void _startTradeFlow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ReadinessTestDialog(
        onResult: (isReady, newStressLevel) {
          setState(() {
            _stressLevel = newStressLevel;
          });
          if (isReady) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF0A0E21),
                title: const Text('آماده معامله هستی!'),
                content: const Text('برو جلو، به استراتژی خودت اعتماد کن. موفق باشی!'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('باشه')),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF0A0E21),
                title: const Text('یک قدم صبر کن'),
                content: Text(_getAdviceMessage()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MeditationPage()));
                    },
                    child: const Text('برو مدیتیشن'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _getAdviceMessage() {
    if (_sleepHours < 5) return 'خواب کافی نداشتی. ذهنت خسته‌ست، بهتره اول یک چرت کوتاه بزنی.';
    if (_stressLevel > 7) return 'استرست بالاست! تمرین تنفسی انجام بده تا ذهنت آروم بگیره.';
    return 'به نظر میرسه الان شرایط مناسبی برای معامله نداری. یه قدم بزن، آب بنوش یا مدیتیشن کن و بعد برگرد.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _refreshData(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [getAdviceColor(), getAdviceColor().withAlpha(80)]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text('وضعیت امروز برای معامله', style: TextStyle(fontSize: 18)),
                              const SizedBox(height: 10),
                              Text(getTradingAdvice(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              if (!_hasPermission)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '⚠️ برای دیدن قدم، ضربان قلب و خواب، دسترسی بده',
                                    style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(200)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(child: _buildHealthCard('قدم‌ها', _steps.toString(), 'گام', Icons.directions_walk)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildHealthCard('ضربان قلب', _heartRate == 0 ? '---' : '$_heartRate', 'BPM', Icons.favorite)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(child: _buildHealthCard('خواب', _sleepHours.toStringAsFixed(1), 'ساعت', Icons.bedtime)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildHealthCard('استرس', '$_stressLevel', '/10', Icons.psychology)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _refreshData,
                                icon: const Icon(Icons.refresh),
                                label: const Text('بروزرسانی دیتا'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFF9A825),
                                  side: const BorderSide(color: Color(0xFFF9A825)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _startTradeFlow,
                                icon: const Icon(Icons.trending_up),
                                label: const Text('شروع معامله هوشمند'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF9A825),
                                  foregroundColor: const Color(0xFF0A0E21),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(String title, String value, String unit, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E21),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF9A825).withAlpha(77)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 35, color: const Color(0xFFF9A825)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(unit, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// ==================== تست آمادگی ذهنی ====================
class ReadinessTestDialog extends StatefulWidget {
  final Function(bool isReady, int stressLevel) onResult;

  const ReadinessTestDialog({super.key, required this.onResult});

  @override
  State<ReadinessTestDialog> createState() => _ReadinessTestDialogState();
}

class _ReadinessTestDialogState extends State<ReadinessTestDialog> {
  int _stressLevel = 5;
  String _sleepQuality = 'medium';
  bool _hasJournaled = false;
  bool _hasMeditated = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0A0E21),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.psychology, size: 50, color: Color(0xFFF9A825)),
            const SizedBox(height: 15),
            const Text('چقدر آماده‌ای؟', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('سطح استرس:'),
              Text('$_stressLevel / 10', style: const TextStyle(color: Color(0xFFF9A825))),
            ]),
            Slider(
              value: _stressLevel.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: const Color(0xFFF9A825),
              onChanged: (val) => setState(() => _stressLevel = val.round()),
            ),
            const SizedBox(height: 15),

            const Text('کیفیت خواب دیشب:'),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'good', label: Text('😴 خوب')),
                ButtonSegment(value: 'medium', label: Text('🫤 متوسط')),
                ButtonSegment(value: 'bad', label: Text('😫 بد')),
              ],
              selected: {_sleepQuality},
              onSelectionChanged: (val) => setState(() => _sleepQuality = val.first),
            ),
            const SizedBox(height: 15),

            CheckboxListTile(
              title: const Text('امروز ژورنال معاملاتی نوشتم؟'),
              value: _hasJournaled,
              onChanged: (val) => setState(() => _hasJournaled = val!),
              activeColor: const Color(0xFFF9A825),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            CheckboxListTile(
              title: const Text('امروز مدیتیشن کردم؟'),
              value: _hasMeditated,
              onChanged: (val) => setState(() => _hasMeditated = val!),
              activeColor: const Color(0xFFF9A825),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int score = _calculateReadinessScore();
                bool isReady = score >= 7;
                widget.onResult(isReady, _stressLevel);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9A825),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('شروع معامله'),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateReadinessScore() {
    int score = 10 - _stressLevel;
    if (_sleepQuality == 'good') score += 2;
    if (_sleepQuality == 'medium') score += 1;
    if (_hasJournaled) score += 1;
    if (_hasMeditated) score += 1;
    return score.clamp(0, 10);
  }
}

// ==================== چالش‌های روزانه ====================
class DailyChallengesPage extends StatefulWidget {
  const DailyChallengesPage({super.key});

  @override
  State<DailyChallengesPage> createState() => _DailyChallengesPageState();
}

class _DailyChallengesPageState extends State<DailyChallengesPage> {
  List<Challenge> _challenges = [];
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
    _loadPoints();
  }

  void _loadChallenges() {
    final today = DateTime.now();
    _challenges = [
      Challenge(id: '1', title: 'نفس عمیق', description: 'قبل از اولین معامله ۵ دقیقه نفس عمیق بکش', points: 50, date: today),
      Challenge(id: '2', title: 'قدم زدن', description: 'حداقل ۱۰۰۰ قدم امروز بردار', points: 100, date: today),
      Challenge(id: '3', title: 'مدیتیشن', description: '۵ دقیقه مدیتیشن کن', points: 75, date: today),
      Challenge(id: '4', title: 'ژورنال نویسی', description: 'امروز ژورنال معاملاتی بنویس', points: 150, date: today),
      Challenge(id: '5', title: 'آب خوردن', description: '۸ لیوان آب امروز بنوش', points: 30, date: today),
    ];
  }

  void _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalPoints = prefs.getInt('totalPoints') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('چالش‌های امروز', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('با انجام چالش‌ها امتیاز بگیر', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF9A825), Color(0xFF0A0E21)]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('امتیاز شما:', style: TextStyle(fontSize: 18)),
                    Text('$_totalPoints', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _challenges.length,
                  itemBuilder: (context, index) => _buildChallengeCard(_challenges[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return Card(
      color: const Color(0xFF0A0E21),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(challenge.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(challenge.description, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  Text('+${challenge.points} امتیاز', style: const TextStyle(color: Color(0xFFF9A825), fontSize: 12)),
                ],
              ),
            ),
            if (challenge.isCompleted)
              const Icon(Icons.check_circle, color: Colors.green, size: 30)
            else
              ElevatedButton(
                onPressed: () => _completeChallenge(challenge),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9A825),
                  foregroundColor: const Color(0xFF0A0E21),
                ),
                child: const Text('انجام دادم'),
              ),
          ],
        ),
      ),
    );
  }

  void _completeChallenge(Challenge challenge) async {
    setState(() {
      challenge.isCompleted = true;
      _totalPoints += challenge.points;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPoints', _totalPoints);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🎉 آفرین! ${challenge.points} امتیاز گرفتی'), backgroundColor: Colors.green),
    );
  }
}

// ==================== مدیتیشن ====================
class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  bool _isMeditating = false;
  int _secondsRemaining = 0;
  Timer? _timer;
  String _currentPhase = 'آماده‌ای؟';
  final List<String> _breathingPhases = ['دم', 'نگه‌داری', 'بازدم', 'نگه‌داری'];
  int _phaseIndex = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBreathingExercise() {
    setState(() {
      _isMeditating = true;
      _secondsRemaining = 300;
      _phaseIndex = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _phaseIndex = (_phaseIndex + 1) % _breathingPhases.length;
        _currentPhase = _breathingPhases[_phaseIndex];

        if (_secondsRemaining > 0) {
          _secondsRemaining -= 4;
        } else {
          _stopMeditation();
        }
      });
    });
  }

  void _stopMeditation() {
    _timer?.cancel();
    setState(() {
      _isMeditating = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🌟 مدیتیشن تموم شد! ذهنت آماده معاملاته')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 4),
                width: _isMeditating ? 250 : 200,
                height: _isMeditating ? 250 : 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFFF9A825), Color(0xFF0A0E21)]),
                  boxShadow: _isMeditating ? [BoxShadow(color: const Color(0xFFF9A825).withAlpha(128), blurRadius: 30, spreadRadius: 10)] : [],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isMeditating) ...[
                        Text(_currentPhase, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 10),
                        Text('${(_secondsRemaining / 60).floor()}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 20, color: Colors.white70)),
                      ] else ...[
                        const Icon(Icons.self_improvement, size: 80, color: Colors.white),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              if (!_isMeditating) ...[
                const Text('تمرین تنفس ۵ دقیقه‌ای', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('دم ۴ ثانیه - نگه‌داری ۴ ثانیه - بازدم ۴ ثانیه', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMeditationCard('🧘', 'مدیتیشن', '۱۰ دقیقه', () {}),
                    const SizedBox(width: 20),
                    _buildMeditationCard('🌊', 'تنفس عمیق', '۵ دقیقه', _startBreathingExercise),
                  ],
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: _stopMeditation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: const Text('پایان مدیتیشن'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationCard(String emoji, String title, String duration, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0E21),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFF9A825).withAlpha(77)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(duration, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ==================== مقایسه ====================
class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  TraderComparison _comparison = TraderComparison();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComparisonData();
  }

  void _loadComparisonData() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _comparison = TraderComparison(
          userSteps: 4500,
          avgSteps: 7500,
          userSleep: 6,
          avgSleep: 7,
          userStress: 7,
          avgStress: 5,
          userJournal: true,
          journalPercentage: 65,
        );
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('مقایسه با تریدرهای دیگه', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('ببین نسبت به بقیه تریدرها چطور هستی', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),
                      _buildComparisonCard('قدم روزانه', '${_comparison.userSteps}', '${_comparison.avgSteps}', Icons.directions_walk, _comparison.userSteps > _comparison.avgSteps),
                      const SizedBox(height: 15),
                      _buildComparisonCard('ساعت خواب', '${_comparison.userSleep}', '${_comparison.avgSleep}', Icons.bedtime, _comparison.userSleep >= _comparison.avgSleep),
                      const SizedBox(height: 15),
                      _buildComparisonCard('سطح استرس', '${_comparison.userStress}', '${_comparison.avgStress}', Icons.psychology, _comparison.userStress <= _comparison.avgStress),
                      const SizedBox(height: 15),
                      Card(
                        color: const Color(0xFF0A0E21),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('ژورنال نویسی', style: TextStyle(fontSize: 16)),
                                Text('مقایسه با دیگران', style: TextStyle(color: Colors.grey)),
                              ]),
                              const SizedBox(height: 15),
                              Row(children: [
                                Expanded(child: Column(children: [
                                  const Text('شما', style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 5),
                                  Icon(_comparison.userJournal ? Icons.check_circle : Icons.cancel, color: _comparison.userJournal ? Colors.green : Colors.red),
                                  const SizedBox(height: 5),
                                  Text(_comparison.userJournal ? 'فعال' : 'غیرفعال'),
                                ])),
                                Expanded(child: Column(children: [
                                  const Text('سایر تریدرها', style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 5),
                                  Text('${_comparison.journalPercentage}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const Text('ژورنال مینویسند'),
                                ])),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9A825).withAlpha(26),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFF9A825)),
                        ),
                        child: Column(children: [
                          const Icon(Icons.lightbulb, color: Color(0xFFF9A825), size: 30),
                          const SizedBox(height: 10),
                          Text(_getAdvice(), style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                        ]),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildComparisonCard(String title, String userValue, String avgValue, IconData icon, bool isBetter) {
    return Card(
      color: const Color(0xFF0A0E21),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [Icon(icon, color: const Color(0xFFF9A825)), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 16))]),
            Icon(isBetter ? Icons.arrow_upward : Icons.arrow_downward, color: isBetter ? Colors.green : Colors.red),
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [const Text('شما', style: TextStyle(color: Colors.grey)), const SizedBox(height: 5), Text(userValue, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))]),
            Column(children: [const Text('میانگین', style: TextStyle(color: Colors.grey)), const SizedBox(height: 5), Text(avgValue, style: const TextStyle(fontSize: 20))]),
          ]),
        ]),
      ),
    );
  }

  String _getAdvice() {
    if (_comparison.userSteps < _comparison.avgSteps) return '💡 قدم‌هات از میانگین کمتره! سعی کن روزی ۱۰۰۰ قدم بیشتر بربداری';
    if (_comparison.userStress > _comparison.avgStress) return '🧘 استرست بالاتر از میانگینه! تمرینات تنفسی رو بیشتر انجام بده';
    if (_comparison.userSleep < _comparison.avgSleep) return '😴 خواب کافی نداشتی! سعی کن زودتر بخوابی تا کیفیت معاملاتت بهتر بشه';
    return '🎉 عالیه! داری بهتر از میانگین تریدرها عمل میکنی';
  }
}

// ==================== تنظیمات ====================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _voiceReminders = true;
  bool _physicalAlert = true;
  String _telegramId = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _voiceReminders = prefs.getBool('voiceReminders') ?? true;
      _physicalAlert = prefs.getBool('physicalAlert') ?? true;
      _telegramId = prefs.getString('telegramId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تنظیمات', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                Card(
                  color: const Color(0xFF0A0E21),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('🔊 یادآوری‌های صوتی هوشمند'),
                        subtitle: const Text('یادآوری برای قدم زدن و استراحت'),
                        value: _voiceReminders,
                        onChanged: (v) => setState(() => _voiceReminders = v),
                        activeTrackColor: const Color(0xFFF9A825),
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('⚠️ هشدار فیزیکی'),
                        subtitle: const Text('لرزش و زنگ هشدار در شرایط بحرانی'),
                        value: _physicalAlert,
                        onChanged: (v) => setState(() => _physicalAlert = v),
                        activeTrackColor: const Color(0xFFF9A825),
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('📱 اتصال به تلگرام'),
                        subtitle: const Text('دریافت نوتیفیکیشن در تلگرام'),
                        value: _telegramId.isNotEmpty,
                        onChanged: (v) {
                          if (v) {
                            _showTelegramDialog();
                          } else {
                            setState(() => _telegramId = '');
                          }
                        },
                        activeTrackColor: const Color(0xFFF9A825),
                      ),
                      if (_telegramId.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('آیدی: $_telegramId', style: const TextStyle(color: Colors.green)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save),
                  label: const Text('ذخیره تنظیمات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9A825),
                    foregroundColor: const Color(0xFF0A0E21),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTelegramDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0E21),
        title: const Text('اتصال به تلگرام'),
        content: TextField(
          onChanged: (v) => _telegramId = v,
          decoration: const InputDecoration(hintText: '@username', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('ذخیره', style: TextStyle(color: Color(0xFFF9A825))),
          ),
        ],
      ),
    );
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voiceReminders', _voiceReminders);
    await prefs.setBool('physicalAlert', _physicalAlert);
    await prefs.setString('telegramId', _telegramId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تنظیمات ذخیره شد'), backgroundColor: Colors.green),
    );
  }
}
