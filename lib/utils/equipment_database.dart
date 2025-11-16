import '../models/equipment.dart';

class EquipmentDatabase {
  static final List<Equipment> allEquipment = [
    Equipment(
      className: 'test-tube',
      nameEnglish: 'Test Tube',
      nameKhmer: 'បំពង់សាក',
      category: 'Glassware',
      categoryKhmer: 'ឧបករណ៍កែវ',
      usage: 'Used for holding, mixing, or heating small quantities of liquid or solid chemicals during laboratory experiments. Can withstand heating with a Bunsen burner.',
      icon: 'science',
      tags: ['chemistry', 'laboratory', 'glass', 'experiment', 'sample'],
    ),
    Equipment(
      className: 'beaker',
      nameEnglish: 'Beaker',
      nameKhmer: 'ពែង',
      category: 'Glassware',
      categoryKhmer: 'ឧបករណ៍កែវ',
      usage: 'A cylindrical container with a flat bottom used for stirring, mixing and heating liquids. Graduated markings on the side provide volume measurements.',
      icon: 'water',
      tags: ['chemistry', 'measurement', 'mixing', 'laboratory'],
    ),
    Equipment(
      className: 'flask',
      nameEnglish: 'Flask',
      nameKhmer: 'ពែងពពុះ',
      category: 'Glassware',
      categoryKhmer: 'ឧបករណ៍កែវ',
      usage: 'Used for containing chemical reactions and for heating, boiling, or mixing chemicals. The narrow neck helps prevent spills and allows for easy swirling.',
      icon: 'flask',
      tags: ['chemistry', 'experiment', 'heating', 'reaction'],
    ),
    Equipment(
      className: 'graduated-cylinder',
      nameEnglish: 'Graduated Cylinder',
      nameKhmer: 'ស៊ីឡាំងបញ្ឈរមានខ្នាត',
      category: 'Measurement',
      categoryKhmer: 'ឧបករណ៍វាស់',
      usage: 'Precisely measures volumes of liquids. More accurate than beakers for measuring specific volumes. Should be read at eye level at the bottom of the meniscus.',
      icon: 'beaker',
      tags: ['measurement', 'volume', 'precision', 'laboratory'],
    ),
    Equipment(
      className: 'petri-dish',
      nameEnglish: 'Petri Dish',
      nameKhmer: 'ចានពេត្រី',
      category: 'Culture Dish',
      categoryKhmer: 'ឧបករណ៍ដាំដុះ',
      usage: 'A shallow circular dish with a lid used to culture microorganisms such as bacteria, fungi, and small plants. Often contains agar growth medium.',
      icon: 'disc',
      tags: ['biology', 'culture', 'bacteria', 'growth'],
    ),
    Equipment(
      className: 'microscope',
      nameEnglish: 'Microscope',
      nameKhmer: 'មីក្រូទស្សន៍',
      category: 'Optical Instrument',
      categoryKhmer: 'ឧបករណ៍អុបទិក',
      usage: 'An optical instrument that magnifies tiny objects and organisms invisible to the naked eye. Used to observe cells, microorganisms, and small structures.',
      icon: 'eye',
      tags: ['biology', 'observation', 'cells', 'magnification'],
    ),
    Equipment(
      className: 'bunsen-burner',
      nameEnglish: 'Bunsen Burner',
      nameKhmer: 'កុងតាំងបឺនសិន',
      category: 'Heating Equipment',
      categoryKhmer: 'ឧបករណ៍កំដៅ',
      usage: 'A gas burner used to heat substances in the laboratory. Produces a hot, clean flame by mixing gas with air. Always use with proper safety precautions.',
      icon: 'flame',
      tags: ['heating', 'fire', 'safety', 'experiment'],
    ),
    Equipment(
      className: 'pipette',
      nameEnglish: 'Pipette',
      nameKhmer: 'ពីប៉ែត',
      category: 'Transfer Tool',
      categoryKhmer: 'ឧបករណ៍ផ្ទេរ',
      usage: 'Used to accurately transfer small volumes of liquid from one container to another. Can be manual or automatic with precise volume control.',
      icon: 'water_drop',
      tags: ['transfer', 'precision', 'measurement', 'liquid'],
    ),
    Equipment(
      className: 'funnel',
      nameEnglish: 'Funnel',
      nameKhmer: 'ផែនផ្កា',
      category: 'Transfer Tool',
      categoryKhmer: 'ឧបករណ៍ផ្ទេរ',
      usage: 'Used to pour liquids or fine-grained substances into containers with small openings. Also used for filtration when lined with filter paper.',
      icon: 'filter',
      tags: ['transfer', 'filtration', 'pouring', 'laboratory'],
    ),
    Equipment(
      className: 'stirring-rod',
      nameEnglish: 'Stirring Rod',
      nameKhmer: 'ដំបងកូរ',
      category: 'Mixing Tool',
      categoryKhmer: 'ឧបករណ៍កូរ',
      usage: 'A glass or plastic rod used to stir solutions and mixtures. Helps dissolve solids in liquids and ensures uniform mixing of chemicals.',
      icon: 'swap_horizontal',
      tags: ['mixing', 'stirring', 'laboratory', 'glass'],
    ),
    Equipment(
      className: 'thermometer',
      nameEnglish: 'Thermometer',
      nameKhmer: 'ទែម៉ូម៉ែត្រ',
      category: 'Measurement',
      categoryKhmer: 'ឧបករណ៍វាស់',
      usage: 'Measures temperature of substances. Laboratory thermometers can measure a wide range of temperatures from very cold to very hot.',
      icon: 'thermostat',
      tags: ['temperature', 'measurement', 'monitoring', 'laboratory'],
    ),
    Equipment(
      className: 'magnet',
      nameEnglish: 'Magnet',
      nameKhmer: 'មេអំបោះ',
      category: 'Physics Tool',
      categoryKhmer: 'ឧបករណ៍រូបវិទ្យា',
      usage: 'Produces a magnetic field and attracts magnetic materials like iron, nickel, and cobalt. Used to demonstrate magnetic properties and separate magnetic materials.',
      icon: 'magnet',
      tags: ['physics', 'magnetism', 'attraction', 'field'],
    ),
    Equipment(
      className: 'magnifying-glass',
      nameEnglish: 'Magnifying Glass',
      nameKhmer: 'កញ្ចក់ពង្រីក',
      category: 'Optical Instrument',
      categoryKhmer: 'ឧបករណ៍អុបទិក',
      usage: 'A convex lens that magnifies objects, making them appear larger. Used for close examination of small objects, insects, or text.',
      icon: 'search',
      tags: ['magnification', 'observation', 'lens', 'examination'],
    ),
    Equipment(
      className: 'balance-scale',
      nameEnglish: 'Balance Scale',
      nameKhmer: 'ជញ្ជីង',
      category: 'Measurement',
      categoryKhmer: 'ឧបករណ៍វាស់',
      usage: 'Measures the mass of objects by comparing them to known weights. Essential for accurate measurements in chemistry experiments.',
      icon: 'balance',
      tags: ['measurement', 'mass', 'weighing', 'precision'],
    ),
    Equipment(
      className: 'safety-goggles',
      nameEnglish: 'Safety Goggles',
      nameKhmer: 'វ៉ែនតាសុវត្ថិភាព',
      category: 'Safety Equipment',
      categoryKhmer: 'ឧបករណ៍សុវត្ថិភាព',
      usage: 'Protective eyewear that shields eyes from chemical splashes, flying debris, and harmful substances. Must be worn at all times in the laboratory.',
      icon: 'visibility',
      tags: ['safety', 'protection', 'eye', 'laboratory'],
    ),
    Equipment(
      className: 'lab-coat',
      nameEnglish: 'Lab Coat',
      nameKhmer: 'អាវបន្ទប់ពិសោធន៍',
      category: 'Safety Equipment',
      categoryKhmer: 'ឧបករណ៍សុវត្ថិភាព',
      usage: 'Protective clothing worn to shield the body and regular clothes from chemical spills, stains, and contamination. Essential safety equipment in laboratories.',
      icon: 'shield',
      tags: ['safety', 'protection', 'clothing', 'laboratory'],
    ),
  ];

  static Equipment? getEquipmentByClass(String className) {
    try {
      return allEquipment.firstWhere(
        (equipment) => equipment.className.toLowerCase() == className.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static List<Equipment> searchEquipment(String query) {
    if (query.isEmpty) return allEquipment;
    
    final lowerQuery = query.toLowerCase();
    return allEquipment.where((equipment) {
      return equipment.nameEnglish.toLowerCase().contains(lowerQuery) ||
          equipment.nameKhmer.contains(query) ||
          equipment.category.toLowerCase().contains(lowerQuery) ||
          equipment.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
