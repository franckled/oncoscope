import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/referentiel.dart';
import 'annexe_screen.dart';
import 'pathology_screen.dart';

/// Met en minuscules et retire les accents pour une recherche tolérante.
String normalizeText(String input) {
  final s = input
      .toLowerCase()
      .replaceAll('œ', 'oe')
      .replaceAll('æ', 'ae')
      .replaceAll('’', "'");
  const from = 'àâäáãåçéèêëíìîïñóòôöõúùûüýÿ';
  const to = 'aaaaaaceeeeiiiinooooouuuuyy';
  final buffer = StringBuffer();
  for (final rune in s.runes) {
    final ch = String.fromCharCode(rune);
    final i = from.indexOf(ch);
    buffer.write(i >= 0 ? to[i] : ch);
  }
  return buffer.toString();
}

class SearchEntry {
  SearchEntry({
    required this.title,
    required this.subtitle,
    required this.haystack,
    this.pathology,
    this.annexe,
  });

  final String title;
  final String subtitle;
  final String haystack;
  final Pathology? pathology;
  final Annexe? annexe;
}

List<SearchEntry> _buildIndex() {
  final entries = <SearchEntry>[];
  for (final p in Referentiel.pathologies) {
    for (final s in p.sections) {
      for (final c in s.criteria) {
        final full = c.hasOptions ? '${c.text} ${c.options.join(' ')}' : c.text;
        entries.add(
          SearchEntry(
            title: c.text,
            subtitle: '${p.name} › ${s.title}',
            haystack: normalizeText('${p.name} ${s.title} $full'),
            pathology: p,
          ),
        );
      }
    }
  }
  for (final a in Referentiel.annexes) {
    for (final line in a.lines) {
      entries.add(
        SearchEntry(
          title: line,
          subtitle: 'Annexe ${a.number} — ${a.title}',
          haystack: normalizeText('annexe ${a.number} ${a.title} $line'),
          annexe: a,
        ),
      );
    }
  }
  return entries;
}

final List<SearchEntry> _index = _buildIndex();

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<SearchEntry> _results = const [];
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final words = normalizeText(value)
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final results = <SearchEntry>[];
    if (words.isNotEmpty) {
      for (final e in _index) {
        if (words.every(e.haystack.contains)) {
          results.add(e);
          if (results.length >= 150) break;
        }
      }
    }
    setState(() {
      _query = value.trim();
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Rechercher un critère (ex. triple négatif, Lynch…)',
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              tooltip: 'Effacer',
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _onChanged('');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Tapez un ou plusieurs mots : la recherche porte sur tous '
                  'les critères et sur les annexes.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          : _results.isEmpty
              ? Center(
                  child: Text(
                    'Aucun résultat',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final e = _results[i];
                    return ListTile(
                      title: Text(e.title, maxLines: 4, overflow: TextOverflow.ellipsis),
                      subtitle: Text(e.subtitle),
                      onTap: () {
                        final p = e.pathology;
                        final a = e.annexe;
                        if (p != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => PathologyScreen(pathology: p),
                            ),
                          );
                        } else if (a != null) {
                          openAnnexe(context, a.number);
                        }
                      },
                    );
                  },
                ),
    );
  }
}
