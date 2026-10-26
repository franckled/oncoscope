import 'models.dart';
import 'referentiel.dart';

// Questionnaires « grand public » : chaque question reformule en langage
// courant un ou plusieurs critères du référentiel professionnel (champ
// `covers`, texte exact du critère). Un test vérifie que chaque critère du
// référentiel est couvert par au moins une question.
//
// À faire relire par l'équipe d'oncogénétique avant diffusion publique.

enum PublicScope { you, family, team }

enum Answer { yes, no, unknown }

class PublicQuestion {
  const PublicQuestion({
    required this.id,
    required this.scope,
    required this.text,
    this.help,
    this.covers = const [],
    this.options = const [],
    this.minRequired = 1,
  });

  final String id;
  final PublicScope scope;
  final String text;
  final String? help;

  /// Textes exacts des critères professionnels couverts.
  final List<String> covers;

  /// Si non vide : question à cocher (au moins [minRequired] éléments).
  final List<String> options;
  final int minRequired;

  bool get isChecklist => options.isNotEmpty;
}

class PublicFlow {
  const PublicFlow({
    required this.pathologyId,
    required this.title,
    required this.subtitle,
    required this.questions,
    this.notes = const [],
  });

  final String pathologyId;
  final String title;
  final String subtitle;
  final List<PublicQuestion> questions;
  final List<String> notes;
}

// ---------------------------------------------------------------------------
// Aides de rédaction
// ---------------------------------------------------------------------------

const String _degrees =
    "Proches du 1er degré : parents, frères et sœurs, enfants. Proches du 2e degré : grands-parents, oncles et tantes, petits-enfants, neveux et nièces.";
const String _firstDegree =
    "Proches du 1er degré : parents, frères et sœurs, enfants.";
const String _sameSide =
    "« Même côté de la famille » : le côté de votre père, ou le côté de votre mère.";
const String _lynch =
    "Cancers évocateurs d’un syndrome de Lynch : cancer colorectal, de l’endomètre (utérus), de l’intestin grêle, du bassinet du rein ou des voies urinaires hautes.";
const String _report =
    "Si vous ne savez pas, votre compte rendu d’analyse (anatomopathologie) ou votre médecin peuvent vous le dire.";

String _crit(String pid, String prefix) {
  final p = Referentiel.pathologies.firstWhere((x) => x.id == pid);
  for (final s in p.sections) {
    for (final c in s.criteria) {
      if (c.text.startsWith(prefix)) return c.text;
    }
  }
  throw StateError('Critère introuvable : $pid / $prefix');
}

List<String> _kind(String pid, SectionKind kind) {
  final p = Referentiel.pathologies.firstWhere((x) => x.id == pid);
  final out = <String>[];
  for (final s in p.sections) {
    if (s.kind == kind) {
      for (final c in s.criteria) {
        out.add(c.text);
      }
    }
  }
  return out;
}

PublicQuestion _bio(String pid, String text) => PublicQuestion(
      id: '$pid-bio',
      scope: PublicScope.team,
      text: text,
      help:
          "Cette information se trouve dans le compte rendu d’analyse de la tumeur ; l’équipe qui vous soigne peut vous la donner.",
      covers: _kind(pid, SectionKind.biological),
    );

PublicQuestion _thera(String pid, String text) => PublicQuestion(
      id: '$pid-thera',
      scope: PublicScope.team,
      text: text,
      help: "À poser à l’oncologue qui vous suit.",
      covers: _kind(pid, SectionKind.theranostic),
    );

const String _bioText =
    "L’analyse de votre tumeur a-t-elle montré un résultat particulier pour lequel le laboratoire ou votre équipe recommande une consultation d’oncogénétique ?";

// ---------------------------------------------------------------------------
// Questionnaires
// ---------------------------------------------------------------------------

final List<PublicFlow> publicFlows = [
  _sein(),
  _ovaire(),
  _prostate(),
  _pancreas(),
  _colon(),
  _endometre(),
  _estomac(),
  _polypose(),
  _rein(),
];

PublicFlow? publicFlowFor(String pathologyId) {
  for (final f in publicFlows) {
    if (f.pathologyId == pathologyId) return f;
  }
  return null;
}

PublicFlow _sein() {
  const id = 'sein';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer du sein',
    subtitle: 'Pour vous ou pour un proche',
    notes: const [
      "Si les cancers de votre famille ont été diagnostiqués tardivement, parlez-en tout de même à votre médecin : ces situations sont à discuter.",
    ],
    questions: [
      PublicQuestion(
        id: 'sein-1',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du sein invasif (« infiltrant ») diagnostiqué à 40 ans ou avant ?",
        covers: [_crit(id, 'Cancer du sein infiltrant ≤ 40')],
      ),
      PublicQuestion(
        id: 'sein-2',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du sein « triple négatif » (ou « médullaire ») diagnostiqué à 60 ans ou avant ?",
        help:
            "Triple négatif : la tumeur n’a ni récepteurs hormonaux ni récepteur HER2. $_report",
        covers: [_crit(id, 'Cancer du sein triple négatif')],
      ),
      PublicQuestion(
        id: 'sein-3',
        scope: PublicScope.you,
        text: "Êtes-vous un homme ayant eu un cancer du sein ?",
        covers: [_crit(id, 'Cancer du sein chez un homme')],
      ),
      PublicQuestion(
        id: 'sein-4',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du sein invasif dans les deux seins, dont l’un diagnostiqué à 50 ans ou avant ?",
        covers: [_crit(id, "Cancer du sein infiltrant bilatéral dont l'un")],
      ),
      PublicQuestion(
        id: 'sein-5',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du sein invasif dans les deux seins, dont l’un « triple négatif » ?",
        help: _report,
        covers: [_crit(id, 'Cancer du sein infiltrant bilatéral dont un TN')],
      ),
      PublicQuestion(
        id: 'sein-6',
        scope: PublicScope.you,
        text:
            "Avez-vous eu une tumeur phyllode de haut grade du sein, avec dans votre famille ou chez vous des cancers survenus jeunes (sein, sarcome, tumeur du cerveau, cancer de la surrénale) ?",
        help:
            "Ce critère concerne un possible syndrome de Li-Fraumeni (voir l’annexe 1 côté professionnels). En cas de doute, répondez « Je ne sais pas ».",
        covers: [_crit(id, 'Tumeur Phyllode')],
      ),
      PublicQuestion(
        id: 'sein-7',
        scope: PublicScope.you,
        text:
            "Un médecin a-t-il évoqué un syndrome de Cowden (syndrome lié au gène PTEN) chez vous ?",
        covers: [_crit(id, 'Suspicion d’un syndrome de Cowden')],
      ),
      PublicQuestion(
        id: 'sein-8',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du sein ET un cancer de l’ovaire de type « séreux » ?",
        covers: [_crit(id, 'Cancer du sein et 1 Adénocarcinome séreux')],
      ),
      PublicQuestion(
        id: 'sein-9',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du sein ET un cancer du pancréas (ou des voies biliaires) ?",
        covers: [_crit(id, 'Cancer du sein et 1 Adénocarcinome biliopancréatique')],
      ),
      PublicQuestion(
        id: 'sein-10',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du sein de type « lobulaire infiltrant » ET un cancer de l’estomac de type « diffus » ?",
        covers: [_crit(id, 'Cancer du sein et 1 Cancer gastrique diffus')],
      ),
      PublicQuestion(
        id: 'sein-f1',
        scope: PublicScope.family,
        text:
            "Y a-t-il eu au moins 3 cancers du sein invasifs dans votre famille (1er ou 2e degré), dont un avant 60 ans ?",
        help: _degrees,
        covers: [_crit(id, '3 cas de cancer du sein')],
      ),
      PublicQuestion(
        id: 'sein-f2',
        scope: PublicScope.family,
        text:
            "Y a-t-il eu au moins 2 cancers du sein invasifs dans votre famille (1er ou 2e degré), l’un avant 50 ans et l’autre avant 70 ans ?",
        help: _degrees,
        covers: [_crit(id, '2 cas de cancer du sein infiltrant')],
      ),
      PublicQuestion(
        id: 'sein-f3',
        scope: PublicScope.family,
        text:
            "Un cancer du sein invasif à 50 ans ou avant dans votre famille, ET chez un autre proche (1er ou 2e degré) : un cancer de la prostate à 55 ans ou avant, OU un cancer du pancréas ou des voies biliaires à 60 ans ou avant, OU un cancer de l’ovaire de type séreux à 70 ans ou avant ?",
        help: _degrees,
        covers: [_crit(id, '1 cas cancer du sein infiltrant ≤ 50')],
      ),
      PublicQuestion(
        id: 'sein-f4',
        scope: PublicScope.family,
        text:
            "Y a-t-il eu au moins 2 cancers du sein de type « lobulaire infiltrant » chez vos parents, frères et sœurs ou enfants ?",
        help: _firstDegree,
        covers: [_crit(id, '2 cas de cancer du sein (lobulaire')],
      ),
      PublicQuestion(
        id: 'sein-f5',
        scope: PublicScope.family,
        text:
            "Un cancer du sein de type « lobulaire infiltrant » dans votre famille, ET chez un parent, frère, sœur ou enfant un cancer de l’estomac de type « diffus » ?",
        help: _firstDegree,
        covers: [_crit(id, '1 cas cancer du sein (lobulaire')],
      ),
      PublicQuestion(
        id: 'sein-f6',
        scope: PublicScope.family,
        text:
            "Un cancer du sein avant 46 ans dans votre famille, ET au moins un proche (1er ou 2e degré) atteint avant 56 ans d’un cancer du « spectre Li-Fraumeni » (sein, sarcome des tissus mous, ostéosarcome, tumeur du système nerveux central, cancer de la surrénale) ?",
        help: _degrees,
        covers: [_crit(id, '1 cas de cancer du sein avant 46')],
      ),
      _bio(id, _bioText),
      _thera(
        id,
        "Votre cancer du sein est-il métastatique ou localement avancé, ou diagnostiqué à 35 ans ou avant avec une radiothérapie prévue ? Dans ces cas, un test génétique peut aider à choisir le traitement (par exemple les inhibiteurs de PARP).",
      ),
    ],
  );
}

PublicFlow _ovaire() {
  const id = 'ovaire';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer de l’ovaire',
    subtitle: 'Ovaire, trompe ou péritoine',
    questions: [
      PublicQuestion(
        id: 'ovaire-1',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’ovaire, de la trompe ou du péritoine, de type « séreux de haut grade », diagnostiqué à 70 ans ou avant ?",
        help:
            "Ne sont pas concernées les tumeurs « borderline » et les tumeurs germinales. $_report",
        covers: [_crit(id, "Adénocarcinome de l'ovaire, de la trompe")],
      ),
      PublicQuestion(
        id: 'ovaire-2',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’ovaire ET aussi : un cancer du sein invasif, OU un cancer du pancréas ou des voies biliaires, OU un cancer évocateur d’un syndrome de Lynch, OU certaines tumeurs rares de l’ovaire ou un sarcome associés au syndrome DICER1 ?",
        help: _lynch,
        covers: [_crit(id, 'Cancer de l’ovaire + au moins une')],
      ),
      PublicQuestion(
        id: 'ovaire-f1',
        scope: PublicScope.family,
        text:
            "Y a-t-il eu au moins 2 cancers de l’ovaire, de la trompe ou du péritoine du même côté de la famille, quel que soit l’âge ?",
        help: _sameSide,
        covers: [_crit(id, 'Au moins 2 cas d’adénocarcinome de l\'ovaire')],
      ),
      PublicQuestion(
        id: 'ovaire-f2',
        scope: PublicScope.family,
        text:
            "Un cancer de l’ovaire, de la trompe ou du péritoine dans votre famille, ET chez un parent, frère, sœur ou enfant : un cancer du sein invasif, OU du pancréas ou des voies biliaires, OU de la prostate, OU un cancer évocateur d’un syndrome de Lynch ?",
        help: "$_firstDegree $_lynch",
        covers: [
          _crit(id,
              '1 cas d’adénocarcinome de l\'ovaire, de la trompe ou primitif péritonéal + 1 apparenté'),
        ],
      ),
      PublicQuestion(
        id: 'ovaire-f3',
        scope: PublicScope.family,
        text:
            "Un cancer de l’ovaire, de la trompe ou du péritoine dans votre famille, ET deux autres proches (1er ou 2e degré) du même côté de la famille atteints d’un cancer du sein invasif, du pancréas ou des voies biliaires, de l’ovaire, de la prostate ou d’un cancer évocateur d’un syndrome de Lynch ?",
        help: "$_degrees $_sameSide $_lynch",
        covers: [
          _crit(id,
              '1 cas d’adénocarcinome de l\'ovaire, de la trompe ou primitif péritonéal + 2 apparentés'),
        ],
      ),
      _bio(
        id,
        "L’analyse de votre tumeur a-t-elle montré un résultat particulier (anomalie génétique, « instabilité génomique / HRD positif », perte de certaines protéines « dMMR ») pour lequel le laboratoire ou votre équipe recommande une consultation d’oncogénétique ?",
      ),
    ],
  );
}

PublicFlow _prostate() {
  const id = 'prostate';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer de la prostate',
    subtitle: 'Pour vous ou pour un proche',
    questions: [
      PublicQuestion(
        id: 'prostate-1',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de la prostate diagnostiqué à 50 ans ou avant ?",
        covers: [_crit(id, 'Adénocarcinome prostatique ≤ 50 ans')],
      ),
      PublicQuestion(
        id: 'prostate-2',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de la prostate diagnostiqué à 60 ans ou avant, avec un score de Gleason de 8 ou plus ?",
        help:
            "Le score de Gleason figure dans le compte rendu de la biopsie. $_report",
        covers: [_crit(id, 'Adénocarcinome prostatique ≤ 60 ans et Gleason')],
      ),
      PublicQuestion(
        id: 'prostate-3',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de la prostate ET aussi un cancer du sein ou un cancer du pancréas (ou des voies biliaires) ?",
        covers: [_crit(id, 'Cancer de la prostate + au moins')],
      ),
      PublicQuestion(
        id: 'prostate-f1',
        scope: PublicScope.family,
        text:
            "Y a-t-il eu au moins 3 cancers de la prostate du même côté de la famille (1er ou 2e degré), dont un avant 55 ans ?",
        help: "$_degrees $_sameSide",
        covers: [_crit(id, '3 cas d’adénocarcinomes prostatiques')],
      ),
      PublicQuestion(
        id: 'prostate-f2',
        scope: PublicScope.family,
        text:
            "Un cancer de la prostate à 55 ans ou avant dans votre famille, ET chez un autre proche (1er ou 2e degré) : un cancer du pancréas ou des voies biliaires à 60 ans ou avant, OU un cancer de l’ovaire de type séreux à 70 ans ou avant ?",
        help: _degrees,
        covers: [_crit(id, '1 cas d’adénocarcinome prostatique ≤ 55 ans')],
      ),
      PublicQuestion(
        id: 'prostate-f3',
        scope: PublicScope.family,
        text:
            "Un cancer de la prostate à 60 ans ou avant dans votre famille, ET deux autres proches (1er ou 2e degré) du même côté de la famille atteints d’un cancer du sein invasif, du pancréas ou des voies biliaires, ou de l’ovaire (type séreux) ?",
        help: "$_degrees $_sameSide",
        covers: [_crit(id, '1 cas d’adénocarcinome prostatique ≤ 60 ans')],
      ),
      _bio(id, _bioText),
      _thera(
        id,
        "Votre cancer de la prostate est-il métastatique et résistant à la castration ? Un test génétique peut alors orienter vers un traitement ciblé (inhibiteur de PARP).",
      ),
    ],
  );
}

PublicFlow _pancreas() {
  const id = 'pancreas';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer du pancréas',
    subtitle: 'Pancréas et voies biliaires',
    notes: const [
      "Il n’existe pas de recommandation consensuelle pour les cholangiocarcinomes (cancers des voies biliaires intra- ou extra-hépatiques) : parlez-en à votre médecin.",
      "Si une TIPMP (tumeur intracanalaire papillaire et mucineuse du pancréas) est aussi présente chez vous ou chez un proche, signalez-le : la situation est à discuter.",
    ],
    questions: [
      PublicQuestion(
        id: 'pancreas-1',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un adénocarcinome du pancréas ou des voies biliaires diagnostiqué à 60 ans ou avant ?",
        covers: [_crit(id, 'Adénocarcinome biliopancréatique ≤ 60 ans')],
      ),
      PublicQuestion(
        id: 'pancreas-2',
        scope: PublicScope.you,
        text:
            "Avez-vous eu une tumeur neuroendocrine du duodénum ou du pancréas diagnostiquée avant 50 ans ?",
        covers: [_crit(id, 'Tumeur neuroendocrine duodéno')],
      ),
      PublicQuestion(
        id: 'pancreas-3',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du pancréas ET aussi : un cancer du sein invasif, OU de l’ovaire, OU un mélanome, OU un cancer de la prostate, OU un cancer évocateur d’un syndrome de Lynch ?",
        help: _lynch,
        covers: [_crit(id, 'Cancer du pancréas + au moins')],
      ),
      PublicQuestion(
        id: 'pancreas-f1',
        scope: PublicScope.family,
        text:
            "Y a-t-il eu au moins 3 cancers du pancréas ou des voies biliaires du même côté de la famille, quel que soit l’âge ?",
        help: _sameSide,
        covers: [_crit(id, '3 cas d’adénocarcinome biliopancréatique')],
      ),
      PublicQuestion(
        id: 'pancreas-f2',
        scope: PublicScope.family,
        text:
            "Un cancer du pancréas ou des voies biliaires dans votre famille, ET chez un parent, frère, sœur ou enfant : un cancer du sein invasif, du pancréas ou des voies biliaires, de l’ovaire, un mélanome, un cancer de la prostate ou un cancer évocateur d’un syndrome de Lynch ?",
        help: "$_firstDegree $_lynch",
        covers: [
          _crit(id, '1 cas d’adénocarcinome biliopancréatique + 1 apparenté'),
        ],
      ),
      PublicQuestion(
        id: 'pancreas-f3',
        scope: PublicScope.family,
        text:
            "Un cancer du pancréas ou des voies biliaires dans votre famille, ET deux autres proches (1er ou 2e degré) du même côté de la famille atteints d’un cancer du sein invasif, du pancréas ou des voies biliaires, de l’ovaire, d’un mélanome, d’un cancer de la prostate ou d’un cancer évocateur d’un syndrome de Lynch ?",
        help: "$_degrees $_sameSide $_lynch",
        covers: [
          _crit(id, '1 cas d’adénocarcinome biliopancréatique + 2 apparentés'),
        ],
      ),
      _bio(id, _bioText),
      _thera(
        id,
        "Votre cancer du pancréas ou des voies biliaires est-il métastatique ou localement avancé ? Un test génétique peut alors orienter vers un traitement ciblé (inhibiteur de PARP), si la tumeur est sensible aux sels de platine.",
      ),
    ],
  );
}

PublicFlow _colon() {
  const id = 'colon';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer du côlon',
    subtitle: 'Côlon et rectum (colorectal)',
    notes: const [
      "Un adénome « avancé » (plus de 1 cm, ou avec dysplasie de haut grade) peut compter à la place d’une tumeur, une seule fois, quand il y a plusieurs tumeurs.",
    ],
    questions: [
      PublicQuestion(
        id: 'colon-1',
        scope: PublicScope.you,
        text: "Avez-vous eu un cancer du côlon diagnostiqué à 40 ans ou avant ?",
        covers: [_crit(id, 'Cancer du côlon ≤ 40 ans')],
      ),
      PublicQuestion(
        id: 'colon-2',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer colorectal ET une autre tumeur liée au syndrome de Lynch, la première des deux ayant été diagnostiquée à 50 ans ou avant ?",
        help: _lynch,
        covers: [_crit(id, 'Cancer colorectal et 1 autre tumeur')],
      ),
      PublicQuestion(
        id: 'colon-3',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer colorectal ET deux autres tumeurs liées au syndrome de Lynch, quel que soit l’âge ?",
        help: _lynch,
        covers: [_crit(id, 'Cancer colorectal et 2 autres tumeurs')],
      ),
      PublicQuestion(
        id: 'colon-f1',
        scope: PublicScope.family,
        text:
            "Un cancer colorectal dans votre famille, ET deux autres proches du 1er degré, du même côté de la famille, atteints de tumeurs évocatrices d’un syndrome de Lynch ?",
        help: "$_firstDegree $_sameSide $_lynch",
        covers: [_crit(id, '1 cas de cancer colorectal + 2 apparentés')],
      ),
      _bio(id, _bioText),
    ],
  );
}

PublicFlow _endometre() {
  const id = 'endometre';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer de l’endomètre',
    subtitle: 'Muqueuse de l’utérus',
    notes: const [
      "Pour un cancer de l’endomètre de type séreux de haut grade, consultez plutôt la rubrique « Cancer de l’ovaire ».",
    ],
    questions: [
      PublicQuestion(
        id: 'endometre-1',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’endomètre diagnostiqué à 40 ans ou avant ?",
        covers: [_crit(id, 'Cancer de l’endomètre ≤ 40 ans')],
      ),
      PublicQuestion(
        id: 'endometre-2',
        scope: PublicScope.you,
        text:
            "Un médecin a-t-il évoqué un syndrome de Cowden (syndrome lié au gène PTEN) chez vous ?",
        covers: [_crit(id, 'Suspicion d’un syndrome de Cowden')],
      ),
      PublicQuestion(
        id: 'endometre-3',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’endomètre ET une autre tumeur liée au syndrome de Lynch, la première des deux ayant été diagnostiquée à 50 ans ou avant ?",
        help: _lynch,
        covers: [_crit(id, 'Cancer de l’endomètre et 1 autre tumeur')],
      ),
      PublicQuestion(
        id: 'endometre-4',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’endomètre ET deux autres tumeurs liées au syndrome de Lynch, quel que soit l’âge ?",
        help: _lynch,
        covers: [_crit(id, 'Cancer de l’endomètre et 2 autres tumeurs')],
      ),
      PublicQuestion(
        id: 'endometre-f1',
        scope: PublicScope.family,
        text:
            "Un cancer de l’endomètre dans votre famille, ET deux autres proches du 1er degré, du même côté de la famille, atteints de tumeurs évocatrices d’un syndrome de Lynch ?",
        help: "$_firstDegree $_sameSide $_lynch",
        covers: [_crit(id, '1 cas de cancer de l’endomètre + 2 apparentés')],
      ),
      _bio(id, _bioText),
    ],
  );
}

PublicFlow _estomac() {
  const id = 'estomac';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer de l’estomac',
    subtitle: 'Cancer gastrique',
    questions: [
      PublicQuestion(
        id: 'estomac-1',
        scope: PublicScope.you,
        text: "Avez-vous eu un cancer de l’estomac diagnostiqué à 35 ans ou avant ?",
        covers: [_crit(id, 'Cancer gastrique ≤ 35 ans')],
      ),
      PublicQuestion(
        id: 'estomac-2',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’estomac de type « diffus » (anciennement « en bague à chaton ») diagnostiqué à 50 ans ou avant ?",
        help: _report,
        covers: [_crit(id, 'Cancer gastrique diffus (CGD) ou anciennement')],
      ),
      PublicQuestion(
        id: 'estomac-3',
        scope: PublicScope.you,
        text:
            "Votre compte rendu mentionne-t-il plusieurs foyers de cancer gastrique diffus (carcinome in situ ou foyers « pagétoïdes ») ?",
        covers: [_crit(id, 'Multiples foyers de CGD')],
      ),
      PublicQuestion(
        id: 'estomac-4',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’estomac de type « diffus », quel que soit l’âge, ET une fente labiale ou palatine (bec-de-lièvre) dans vos antécédents ?",
        covers: [_crit(id, 'CGD quel que soit l’âge')],
      ),
      PublicQuestion(
        id: 'estomac-5',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’estomac de type « diffus » ET un cancer du sein de type « lobulaire infiltrant » ?",
        covers: [_crit(id, 'Cancer gastrique diffus et cancer du sein lobulaire')],
      ),
      PublicQuestion(
        id: 'estomac-6',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’estomac à 50 ans ou avant ET une autre tumeur du « spectre étroit » du syndrome de Lynch ?",
        help:
            "Spectre étroit : cancer colorectal, de l’endomètre, de l’intestin grêle, du bassinet du rein ou des voies urinaires hautes.",
        covers: [_crit(id, 'Cancer gastrique ≤ 50 ans et au moins 1')],
      ),
      PublicQuestion(
        id: 'estomac-7',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer de l’estomac ET deux autres tumeurs liées au syndrome de Lynch, quel que soit l’âge ?",
        help: _lynch,
        covers: [_crit(id, 'Cancer gastrique et 2 autres tumeurs')],
      ),
      PublicQuestion(
        id: 'estomac-f1',
        scope: PublicScope.family,
        text:
            "Y a-t-il eu au moins 2 cancers de l’estomac du même côté de la famille, quel que soit l’âge, dont au moins un cancer de type « diffus » confirmé ?",
        help: _sameSide,
        covers: [_crit(id, '2 cas ou plus de cancer gastrique')],
      ),
      PublicQuestion(
        id: 'estomac-f2',
        scope: PublicScope.family,
        text:
            "Un cancer de l’estomac de type « diffus » dans votre famille, ET chez un parent, frère, sœur ou enfant une fente labiale ou palatine ?",
        help: _firstDegree,
        covers: [
          _crit(id, '1 cas de cancer gastrique diffus + 1 apparenté au 1er degré avec fente'),
        ],
      ),
      PublicQuestion(
        id: 'estomac-f3',
        scope: PublicScope.family,
        text:
            "Un cancer de l’estomac de type « diffus » dans votre famille, ET chez un parent, frère, sœur ou enfant un cancer du sein de type « lobulaire infiltrant » ?",
        help: _firstDegree,
        covers: [
          _crit(id, '1 cas de cancer gastrique diffus + 1 apparenté au 1er degré avec un cancer du sein'),
        ],
      ),
      PublicQuestion(
        id: 'estomac-f4',
        scope: PublicScope.family,
        text:
            "Un cancer de l’estomac dans votre famille, ET deux autres proches du 1er degré, du même côté de la famille, atteints de tumeurs évocatrices d’un syndrome de Lynch ?",
        help: "$_firstDegree $_sameSide $_lynch",
        covers: [_crit(id, '1 cas de cancer gastrique + 2 apparentés')],
      ),
      _bio(id, _bioText),
    ],
  );
}

PublicFlow _polypose() {
  const id = 'polypose';
  return PublicFlow(
    pathologyId: id,
    title: 'Polypes digestifs',
    subtitle: 'Polypose (nombreux polypes)',
    notes: const [
      "Les polypes comptés sont ceux qui ont été prouvés par l’analyse au microscope (histologie), lors d’une ou de plusieurs coloscopies successives.",
    ],
    questions: [
      PublicQuestion(
        id: 'polypose-1',
        scope: PublicScope.you,
        text:
            "Vous a-t-on trouvé 15 polypes adénomateux ou plus au total dans le côlon ou le rectum, quel que soit votre âge ?",
        help: "Au total, sur une ou plusieurs coloscopies, confirmés par analyse.",
        covers: [
          _crit(id, 'Nombre cumulé* de polypes adénomateux colorectaux (prouvés histologiquement) ≥ 15'),
        ],
      ),
      PublicQuestion(
        id: 'polypose-2',
        scope: PublicScope.you,
        text:
            "Vous a-t-on trouvé entre 5 et 14 polypes adénomateux au total ? Si oui, cochez ce qui vous concerne (il en faut au moins 2).",
        help: "Si vous n’avez pas eu entre 5 et 14 polypes, ne cochez rien.",
        minRequired: 2,
        options: [
          "Au moins 2 de mes polypes étaient « avancés » (villeux, avec dysplasie de haut grade, de 10 mm ou plus, ou festonnés à risque)",
          "Tous mes polypes sont apparus à 50 ans ou avant",
          "J’ai eu un cancer colorectal à 60 ans ou avant",
          "J’ai eu un cancer du spectre du syndrome de Lynch en dehors du côlon et du rectum",
          "J’ai eu un adénome ou un cancer du duodénum ou de l’ampoule de Vater",
          "J’ai une polypose de l’estomac avec de nombreux petits kystes (glandulo-kystique profuse)",
          "J’ai plusieurs lésions sébacées de la peau",
          "Mes parents sont consanguins",
        ],
        covers: [
          _crit(id, 'Nombre cumulé* de polypes adénomateux colorectaux (prouvés histologiquement) compris'),
        ],
      ),
      PublicQuestion(
        id: 'polypose-3',
        scope: PublicScope.you,
        text: "A-t-on trouvé chez vous une polypose adénomateuse de l’estomac ?",
        covers: [_crit(id, 'Polypose adénomateuse gastrique')],
      ),
      PublicQuestion(
        id: 'polypose-4',
        scope: PublicScope.you,
        text:
            "Avez-vous une polypose ET, dans vos antécédents, l’un de ces éléments ? Cochez ce qui vous concerne.",
        minRequired: 1,
        options: [
          "Tumeur desmoïde",
          "Hépatoblastome",
          "CHRPE unilatérale (tache pigmentée de la rétine, d’un seul œil)",
          "Ostéome (tumeur bénigne de l’os)",
          "Kystes épidermoïdes",
        ],
        covers: [_crit(id, 'Polypose avec des antécédents')],
      ),
      PublicQuestion(
        id: 'polypose-5',
        scope: PublicScope.you,
        text:
            "Un médecin a-t-il évoqué chez vous un syndrome de Peutz-Jeghers, une polypose juvénile ou une maladie de Cowden ?",
        help:
            "Peutz-Jeghers : polypes particuliers et taches pigmentées autour de la bouche. Polypose juvénile : polypes dits « juvéniles ». Cowden : lié au gène PTEN.",
        covers: [_crit(id, 'Phénotype clinique évocateur')],
      ),
      PublicQuestion(
        id: 'polypose-6',
        scope: PublicScope.you,
        text:
            "Un examen des yeux a-t-il montré une hypertrophie congénitale de l’épithélium pigmentaire rétinien (CHRPE) touchant plusieurs zones ou les deux yeux ?",
        covers: [_crit(id, 'Hypertrophie congénitale')],
      ),
    ],
  );
}

PublicFlow _rein() {
  const id = 'rein';
  return PublicFlow(
    pathologyId: id,
    title: 'Cancer du rein',
    subtitle: 'Cancer à cellules rénales',
    questions: [
      PublicQuestion(
        id: 'rein-1',
        scope: PublicScope.you,
        text: "Avez-vous eu plusieurs tumeurs du rein, ou des tumeurs dans les deux reins ?",
        covers: [_crit(id, 'Tumeurs rénales multiples')],
      ),
      PublicQuestion(
        id: 'rein-2',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein à « cellules claires » diagnostiqué à 40 ans ou avant ?",
        help: _report,
        covers: [_crit(id, 'Cancer du rein à cellules claires ≤ 40')],
      ),
      PublicQuestion(
        id: 'rein-3',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein d’un autre type que « cellules claires » (chromophobe, oncocytome, tubulo-papillaire) diagnostiqué à 50 ans ou avant ?",
        help: _report,
        covers: [_crit(id, 'Cancer à cellules rénales toutes autres histologies')],
      ),
      PublicQuestion(
        id: 'rein-4',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein ET un cancer du rein chez un proche du 1er ou du 2e degré ?",
        help: _degrees,
        covers: [_crit(id, 'Cancer du rein + 1 apparenté')],
      ),
      PublicQuestion(
        id: 'rein-5',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein à cellules claires ET aussi : un hémangioblastome (cerveau, moelle, rétine), des kystes ou tumeurs neuroendocrines du pancréas, des kystes du rein, ou un phéochromocytome, paragangliome ou tumeur du sac endolymphatique ?",
        help: "Ces signes évoquent la maladie de Von Hippel-Lindau (VHL).",
        covers: [_crit(id, 'Cancer rénal à cellules claires + signes évocateurs VHL')],
      ),
      PublicQuestion(
        id: 'rein-6',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein ET un paragangliome, un phéochromocytome ou une tumeur stromale digestive (GIST) ?",
        covers: [_crit(id, 'Cancer à cellules rénales + paragangliomes')],
      ),
      PublicQuestion(
        id: 'rein-7',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein ET aussi : un mélanome de l’œil ou de la peau, un mésothéliome (plèvre ou péritoine), ou certaines tumeurs de la peau (carcinomes basocellulaires, tumeurs de Spitz) ?",
        help: "Ces signes évoquent une atteinte du gène BAP1.",
        covers: [_crit(id, 'Cancer à cellules rénales + signes évocateurs BAP1')],
      ),
      PublicQuestion(
        id: 'rein-8',
        scope: PublicScope.you,
        text:
            "Un médecin a-t-il évoqué une maladie de Cowden (syndrome lié au gène PTEN) en plus de votre cancer du rein ?",
        covers: [_crit(id, 'Cancer à cellules rénales + signes évocateurs PTEN')],
      ),
      PublicQuestion(
        id: 'rein-9',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein ET des signes de sclérose tubéreuse de Bourneville (angiomyolipome, épilepsie, retard mental…) ?",
        covers: [_crit(id, 'Cancer à cellules rénales + signes évocateurs TSC1')],
      ),
      PublicQuestion(
        id: 'rein-10',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein de type chromophobe, hybride oncocytique ou un oncocytome, ET aussi : des fibrofolliculomes (petites bosses de la peau du visage ou du cou), un pneumothorax ou des kystes pulmonaires ?",
        help: "Ces signes évoquent le syndrome de Birt-Hogg-Dubé (BHD).",
        covers: [_crit(id, 'Cancer rénal chromophobe')],
      ),
      PublicQuestion(
        id: 'rein-11',
        scope: PublicScope.you,
        text:
            "Avez-vous eu un cancer du rein de type « FH-déficient » (anciennement papillaire de type 2) ET des léiomyomes (fibromes) de l’utérus ou de la peau ?",
        help: "Ces signes évoquent le syndrome HLRCC.",
        covers: [_crit(id, 'Cancer à cellules rénales FH-déficient (anciennement')],
      ),
      _bio(
        id,
        "L’analyse de votre tumeur a-t-elle montré un cancer du rein « SDH-déficient » ou « FH-déficient », ou une autre anomalie génétique pour laquelle une consultation d’oncogénétique est recommandée ?",
      ),
    ],
  );
}
