import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/gacha_calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  int _currentConstellation = 0;
  int _targetConstellation = 6;
  int _currentPrimogems = 0;
  int _currentFates = 0;
  int _pityCount = 0;
  bool _hasGuarantee = false;
  CalculationResult? _result;

  final _primogemsController = TextEditingController();
  final _fatesController = TextEditingController();
  final _pityController = TextEditingController();

  @override
  void dispose() {
    _primogemsController.dispose();
    _fatesController.dispose();
    _pityController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      _currentPrimogems = int.tryParse(_primogemsController.text) ?? 0;
      _currentFates = int.tryParse(_fatesController.text) ?? 0;
      _pityCount = int.tryParse(_pityController.text) ?? 0;

      _result = ConstellationCalculator.calculate(
        currentConstellation: _currentConstellation,
        targetConstellation: _targetConstellation,
        currentPrimogems: _currentPrimogems,
        currentFates: _currentFates,
        pityCount: _pityCount,
        hasGuarantee: _hasGuarantee,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Constellation Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'How to Use',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Calculate how many pulls you need to get from your current constellation to your target constellation. Enter your current resources and pity to get accurate estimates.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Constellation Selection
            Text(
              'Constellation Level',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildConstellationSelector(
                    'Current',
                    _currentConstellation,
                    (value) => setState(() => _currentConstellation = value),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildConstellationSelector(
                    'Target',
                    _targetConstellation,
                    (value) => setState(() => _targetConstellation = value),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: -0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Resources Input
            Text(
              'Current Resources',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _primogemsController,
              label: 'Primogems',
              icon: Icons.diamond,
              hint: '0',
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.2, end: 0),
            
            const SizedBox(height: 12),
            
            _buildTextField(
              controller: _fatesController,
              label: 'Intertwined Fates',
              icon: Icons.auto_awesome,
              hint: '0',
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideX(begin: -0.2, end: 0),
            
            const SizedBox(height: 12),
            
            _buildTextField(
              controller: _pityController,
              label: 'Current Pity',
              icon: Icons.trending_up,
              hint: '0',
              helperText: 'Pulls since last 5-star (0-89)',
            ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideX(begin: -0.2, end: 0),
            
            const SizedBox(height: 16),
            
            // Guarantee Toggle
            SwitchListTile(
              title: const Text('Next 5★ is Guaranteed'),
              subtitle: const Text('Lost 50/50 on last 5-star pull'),
              value: _hasGuarantee,
              onChanged: (value) => setState(() => _hasGuarantee = value),
              activeColor: Theme.of(context).colorScheme.primary,
            ).animate().fadeIn(duration: 400.ms, delay: 500.ms).slideX(begin: -0.2, end: 0),
            
            const SizedBox(height: 24),
            
            // Calculate Button
            ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 600.ms).scale(),
            
            // Results
            if (_result != null) ...[
              const SizedBox(height: 32),
              _buildResultsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConstellationSelector(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          child: DropdownButton<int>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: List.generate(7, (index) {
              return DropdownMenuItem(
                value: index,
                child: Text(
                  'C$index',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
            onChanged: (newValue) {
              if (newValue != null) onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    String? helperText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Results',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
        
        const SizedBox(height: 16),
        
        _buildResultCard(
          'Copies Needed',
          '${_result!.copiesNeeded}',
          Icons.person,
          const Color(0xFFFFB84D),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms).scale(),
        
        const SizedBox(height: 12),
        
        _buildResultCard(
          'Total Pulls Needed',
          '${_result!.totalPullsNeeded}',
          Icons.auto_awesome,
          const Color(0xFF7C4DFF),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(),
        
        const SizedBox(height: 12),
        
        _buildResultCard(
          'Primogems Needed',
          '${_result!.primogemsNeeded}',
          Icons.diamond,
          const Color(0xFF4CC2F1),
        ).animate().fadeIn(duration: 400.ms, delay: 300.ms).scale(),
        
        const SizedBox(height: 16),
        
        // Additional Info
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Probability Ranges',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 24),
                _buildInfoRow('Best Case (lucky)', '~${_result!.bestCasePulls} pulls'),
                const SizedBox(height: 8),
                _buildInfoRow('Average Case', '~${_result!.totalPullsNeeded} pulls'),
                const SizedBox(height: 8),
                _buildInfoRow('Worst Case (unlucky)', '~${_result!.worstCasePulls} pulls'),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildResultCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              Theme.of(context).cardColor,
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

