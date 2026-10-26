import 'package:flutter/material.dart';

import 'models.dart';

// Source : référentiel « Indications de consultations d'oncogénétique »,
// version 1.0 d'octobre 2025. Contenu des critères transcrit tel quel.

const String kSourceTitle =
    "Référentiel « Indications de consultations d’oncogénétique »";
const String kSourceVersion = "Version 1.0 — octobre 2025";
const String kSourceValidity =
    "À revalider avant le 29/10/2027 (date de péremption du référentiel)";

const List<String> kObjet = [
  "Ce référentiel reprend les indications de consultations d’oncogénétique selon les principales pathologies rencontrées. Il est une aide pour tous les cliniciens souhaitant une évaluation de l’existence d’une prédisposition héréditaire aux cancers pour leurs patients et leur prise en charge.",
  "C’est au cours de la consultation d’oncogénétique que l’onco-généticien ou le conseiller en génétique pourra retenir ou non une indication d’analyse génétique. En effet, la prescription de l’analyse est conditionnée par plusieurs éléments tels que l’informativité de l’histoire familiale, le souhait du patient.",
  "Selon le contexte clinique ou en cas de doute, notamment face à des diagnostics tardifs, la demande de consultation peut être soumise à l’évaluation d’une équipe d’oncogénétique.",
  "Les demandes à visée théranostique peuvent être adressées directement à l’équipe d’oncogénétique.",
];

const List<String> kVocabulaire = [
  "Mutation : le terme mutation correspond aux variants pathogènes classe 5 ou probablement pathogènes classe 4 identifiés lors d’une analyse de biologie moléculaire.",
  "Degré de parenté : par rapport à une personne, sont apparentées au 1er degré les parents, les enfants, les frères et sœurs ; au 2nd degré les personnes concernées sont les grands-parents, les oncles/tantes, les petits-enfants et les neveux/nièces.",
  "Remarque : les cousins germains sont des apparentés au 3ème degré.",
];

// Textes récurrents du référentiel.
const String _mutationTumorale =
    "Mutation tumorale identifiée sur un des gènes actionnables donnant lieu à une indication de consultation d’oncogénétique mentionnée par le biologiste.";
const String _dmmrMshA =
    "Phénotype dMMR avec perte d’expression MSH2 / MSH6 (cf. annexe 4).";
const String _dmmrMshB =
    "Phénotype dMMR avec perte d’expression MSH2/MSH6 (cf. annexe 4).";
const String _dmmrMlhA =
    "Phénotype dMMR avec perte d’expression MLH1 / PMS2 sans hyperméthylation du promoteur de MLH1 (cf. annexe 4).";
const String _dmmrMlhB =
    "Phénotype dMMR avec perte d’expression MLH1/PMS2 sans hyperméthylation du promoteur de MLH1 (cf. annexe 4).";
const String _noTheranostic =
    "Pas de critères d’indication d’analyse constitutionnelle et donc de consultation d’oncogénétique en 1ère intention dans un cadre théranostique. (Cf. AMM en vigueur)";
const String _noTheranosticGastric =
    "Pas de critères d’indication de consultation d’oncogénétique en 1ère intention dans un cadre théranostique";
const String _ageFootnoteSomatic =
    "*Selon la configuration familiale, les âges au diagnostic seront pris en compte pour la décision d’analyses génétiques somatiques et/ou constitutionnelles";
const String _adenomaRemark =
    "Remarque : 1 adénome avancé (> 1 cm et/ou dysplasie de haut grade) peut remplacer une (et une seule) tumeur en cas de tumeurs primitives multiples";
const String _parpBreast1 =
    "Cancer du sein métastatique ou localement avancé selon l’AMM des inhibiteurs de PARP.";
const String _parpBreast2 =
    "Cancer du sein isolé ≤ 35 ans dans le cadre d’une indication de radiothérapie adjuvante";
const String _biologicalTitle = "Résultats d’analyse tumorale";

class Referentiel {
  Referentiel._();

  static Annexe? annexe(int number) {
    for (final a in annexes) {
      if (a.number == number) return a;
    }
    return null;
  }

  static const List<Pathology> pathologies = [
    _sein,
    _ovaire,
    _prostate,
    _pancreas,
    _colon,
    _endometre,
    _estomac,
    _polypose,
    _rein,
  ];

  // -------------------------------------------------------------------------
  // 3. Cancer du sein
  // -------------------------------------------------------------------------
  static const Pathology _sein = Pathology(
    id: 'sein',
    name: 'Cancer du sein',
    icon: Icons.favorite_border,
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [Criterion(_mutationTumorale)],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title: 'Cancer du sein isolé',
        criteria: [
          Criterion("Cancer du sein infiltrant ≤ 40 ans"),
          Criterion(
              "Cancer du sein triple négatif (TN ou les anciens cancers médullaires) ≤ 60 ans"),
          Criterion("Cancer du sein chez un homme"),
          Criterion("Cancer du sein infiltrant bilatéral dont l'un ≤ 50 ans"),
          Criterion("Cancer du sein infiltrant bilatéral dont un TN"),
          Criterion(
              "Tumeur Phyllode de haut grade avec critères personnels ou familiaux évocateurs dans le cadre d’un syndrome de Li-Fraumeni (altérations constitutionnelles du gène TP53, cf. annexe 1)"),
          Criterion(
              "Suspicion d’un syndrome de Cowden (altérations constitutionnelles du gène PTEN, cf. annexe 2)"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title: 'Cancer du sein associé à d’autres tumeurs primitives',
        criteria: [
          Criterion("Cancer du sein et 1 Adénocarcinome séreux ovarien"),
          Criterion("Cancer du sein et 1 Adénocarcinome biliopancréatique"),
          Criterion(
              "Cancer du sein et 1 Cancer gastrique diffus si cancer du sein lobulaire infiltrant"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.theranostic,
        title: 'Situation théranostique (cancer isolé ou associé)',
        criteria: [
          Criterion(_parpBreast1),
          Criterion(_parpBreast2),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.familial,
        title: 'Antécédents familiaux',
        criteria: [
          Criterion(
              "3 cas de cancer du sein infiltrant au 1er ou au 2ème degré dont un avant 60 ans"),
          Criterion(
              "2 cas de cancer du sein infiltrant au 1er ou au 2ème degré dont un avant 50 ans et l'autre avant 70 ans"),
          Criterion(
            "1 cas cancer du sein infiltrant ≤ 50 ans + 1 apparenté au 1er ou au 2ème degré atteint de :",
            options: [
              "Cancer de la prostate ≤ 55 ans",
              "Adénocarcinome biliopancréatique ≤ 60 ans",
              "Adénocarcinome séreux ovarien ≤ 70 ans",
            ],
          ),
          Criterion(
              "2 cas de cancer du sein (lobulaire infiltrant) au 1er degré"),
          Criterion(
              "1 cas cancer du sein (lobulaire infiltrant) + 1 apparenté au 1er degré atteint de cancer gastrique diffus"),
          Criterion(
              "1 cas de cancer du sein avant 46 ans et au moins 1 apparenté au 1er ou au 2ème degré atteint de cancers du spectre Li-Fraumeni avant 56 ans (cf. annexe 1)"),
        ],
        footnotes: ["A discuter si diagnostics tardifs"],
      ),
    ],
    references: [
      "Reid S and al. An overview of genetic services delivery for hereditary breast cancer. Breast Cancer Research and Treatment. 2022.",
      "Ntowe KW and al. Clinical genetics in breast cancer. J Surg Oncol. Breast cancer Res Treat. 2024.",
      "Stoffel EM, Current Approaches to germline Cancer Genetic testing. Annu Rev Med. 2020.",
      "Bedrosia I and al. Germline testing in patients with breast cancer : asco society of surgical oncology guideline q and a. JCO Oncol Pract. 2024.",
      "Bouras A and al. Overview of the Genetic Causes of Hereditary Breast and Ovarian Cancer Syndrome in a Large French Patient Cohort. Cancers (Basel). 2023.",
      "Pujol P and al. Clinical practice guidelines for BRCA1 and BRCA2 genetic testing. Eur J Cancer. 2021.",
      "Rezoug Z and al. Universal Genetic Testing for Newly Diagnosed Invasive Breast Cancer. JAMA Netw Open 2024.",
      "Shelton C and al. Universal Germline-Genetic Testing for Breast Cancer Implementation in a Rural Practice and Impact on Shared Decision-Making. Ann Surg Oncol. 2024.",
      "NCCN Clinical Pratice Guidelines in Oncology. Version 3.2025 : Hereditary Cancer Testing Criteria",
      "Tischkowitz M and al. Cancer Surveillance Guideline for individuals with PTEN hamartoma tumour syndrome. Eur J Hum Genet. 2020.",
      "Frebourg T and al. Guidelines for the Li-Fraumeni and heritable TP53-related cancer syndromes. Eur J Hum Genet. 2020.",
    ],
  );

  // -------------------------------------------------------------------------
  // 4. Cancer de l'ovaire
  // -------------------------------------------------------------------------
  static const Pathology _ovaire = Pathology(
    id: 'ovaire',
    name: 'Cancer de l’ovaire',
    icon: Icons.blur_circular,
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [
          Criterion(_mutationTumorale),
          Criterion(
              "Instabilité génomique (test HRD positif) sans mutation BRCA1 / 2 tumorale identifiée"),
          Criterion(_dmmrMshA),
          Criterion(_dmmrMlhA),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title: 'Cancer de l’ovaire isolé',
        criteria: [
          Criterion(
              "Adénocarcinome de l'ovaire, de la trompe ou primitif péritonéal principalement séreux de haut grade (hors tumeurs borderline ou germinales) ≤ 70 ans"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title: 'Cancer de l’ovaire associé à d’autres tumeurs primitives',
        criteria: [
          Criterion(
            "Cancer de l’ovaire + au moins une des tumeurs primitives suivantes :",
            options: [
              "Cancer du sein infiltrant",
              "Adénocarcinome biliopancréatique et/ou TIPMP",
              "Cancer évocateur d’un syndrome de Lynch (cf. annexe 3)",
              "Tumeur ovarienne de type Sertoli-Leydig ou de la granulosa et sarcome ovarien ou tumeur des cordons sexuels associée à des tumeurs du spectre DICER1 (cf. annexe 5)",
            ],
          ),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.theranostic,
        title: 'Situation théranostique',
        statement: _noTheranostic,
      ),
      CriteriaSection(
        kind: SectionKind.familial,
        title: 'Antécédents familiaux',
        criteria: [
          Criterion(
              "Au moins 2 cas d’adénocarcinome de l'ovaire, de la trompe ou primitif péritonéal dans la même branche parentale quel que soit l’âge"),
          Criterion(
            "1 cas d’adénocarcinome de l'ovaire, de la trompe ou primitif péritonéal + 1 apparenté au 1er degré atteint de :",
            options: [
              "Cancer du sein infiltrant",
              "Adénocarcinome biliopancréatique et/ou TIPMP",
              "Adénocarcinome prostatique",
              "Cancer évocateur d'un syndrome de Lynch (cf. annexe 3)",
            ],
          ),
          Criterion(
            "1 cas d’adénocarcinome de l'ovaire, de la trompe ou primitif péritonéal + 2 apparentés au 1er ou 2ème degré dans la même branche parentale quel que soit l’âge atteint de :",
            options: [
              "Cancer du sein infiltrant",
              "Adénocarcinome biliopancréatique et/ou TIPMP",
              "Adénocarcinome ovarien",
              "Adénocarcinome prostatique",
              "Cancer évocateur d'un syndrome de Lynch (cf. annexe 3)",
            ],
          ),
        ],
      ),
    ],
    references: [
      "Bull Cancer 2021; 108: S33–S38 Diagnostic histologique et moléculaire des cancers de l’ovaire – recommandations pour la pratique clinique Saint-Paul 2021",
      "Institut National du cancer. Inhibiteurs de PARP: préconisations pour un parcours en génétique oncologique. 2019.",
      "NCCN Clinical Pratice Guidelines in Oncology. Version 2.2025.",
      "ESGO–ESMO–ESP consensus conference recommendations on ovarian cancer: pathology and molecular biology and early, advanced and recurrent disease Ann Oncol. 2024;35(3):248-266 J.",
      "Ledermann, X. Matias-Guiu, F. Amant, et al. Bull Cancer vol. 99 • N◦ 4 • avril 2012 Les formes héréditaires des cancers de l’ovaire",
    ],
  );

  // -------------------------------------------------------------------------
  // 5. Cancer de la prostate
  // -------------------------------------------------------------------------
  static const Pathology _prostate = Pathology(
    id: 'prostate',
    name: 'Cancer de la prostate',
    icon: Icons.male,
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [Criterion(_mutationTumorale)],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title: 'Cancer de la prostate isolé',
        criteria: [
          Criterion("Adénocarcinome prostatique ≤ 50 ans"),
          Criterion("Adénocarcinome prostatique ≤ 60 ans et Gleason ≥ 8"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title: 'Cancer de la prostate associé à d’autres tumeurs primitives',
        criteria: [
          Criterion(
            "Cancer de la prostate + au moins une des tumeurs primitives suivantes :",
            options: [
              "Cancer du sein",
              "Adénocarcinome biliopancréatique",
            ],
          ),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.theranostic,
        title: 'Situation théranostique (cancer isolé ou associé)',
        criteria: [
          Criterion(
              "Adénocarcinome prostatique métastatique résistant à la castration quel que soit l’âge (enjeu potentiel d'une thérapie ciblée par inhibiteur de PARP, cf. AMM en vigueur)"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.familial,
        title: 'Antécédents familiaux',
        criteria: [
          Criterion(
              "3 cas d’adénocarcinomes prostatiques dans la même branche parentale, apparentés au 1er ou 2ème degré dont au moins un cas < 55 ans"),
          Criterion(
            "1 cas d’adénocarcinome prostatique ≤ 55 ans + 1 apparenté au 1er ou au 2ème degré atteint de :",
            options: [
              "Adénocarcinome biliopancréatique ≤ 60 ans",
              "Adénocarcinome séreux ovarien ≤ 70 ans",
            ],
          ),
          Criterion(
            "1 cas d’adénocarcinome prostatique ≤ 60 ans + 2 apparentés au 1er ou 2ème degré dans la même branche parentale quel que soit l’âge atteint de* :",
            options: [
              "Cancer du sein infiltrant",
              "Adénocarcinome biliopancréatique",
              "Adénocarcinome séreux ovarien",
            ],
          ),
        ],
        footnotes: [
          "*Selon la configuration familiale, les âges au diagnostic seront pris en compte pour la décision d’analyses génétiques",
        ],
      ),
    ],
    references: [
      "Veda N. Giri et al. Implementation of Germline Testing for Prostate Cancer: Philadelphia Prostate Cancer Consensus Conference 2019. JCO 38, 2798-2811(2020).",
      "Cheng HH, Sokolova AO, Schaeffer EM, Small EJ, Higano CS. Germline and Somatic Mutations in Prostate Cancer for the Clinician. J Natl Compr Canc Netw. 2019 May 1;17(5):515-521",
      "NCNN Clinical Practice Guidelines in Oncology, Prostate Cancer, Version 4.2023",
      "Russo J, Giri VN. Germline testing and genetic counselling in prostate cancer. Nat Rev Urol. 2022 Jun;19(6):331-343.",
      "Oudard S, Timsit MO, Maillet D, Mouillet G, Campedel L, Colomba É, Dourthe LM, Eymard JC, Gobert A, Jamet C, Joly C, Serrate C, Ploussard G. Cancer de prostate métastatique résistant à la castration et inhibiteurs de PARP : de la génomique tumorale aux nouvelles associations. Bull Cancer. 2025",
      "Commission de la transparence avis 5 mai 2021, olaparib.",
    ],
  );

  // -------------------------------------------------------------------------
  // 6. Cancer du pancréas
  // -------------------------------------------------------------------------
  static const Pathology _pancreas = Pathology(
    id: 'pancreas',
    name: 'Cancer du pancréas',
    icon: Icons.science_outlined,
    notes: [
      "NB : Il n’existe pas de recommandations consensuelles pour les cas de cholangiocarcinome",
    ],
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [
          Criterion(_mutationTumorale),
          Criterion(_dmmrMshA),
          Criterion(_dmmrMlhA),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title: 'Cancer du pancréas isolé',
        criteria: [
          Criterion("Adénocarcinome biliopancréatique ≤ 60 ans"),
          Criterion(
              "Tumeur neuroendocrine duodéno pancréatique < 50 ans (cf. https://www.reseau-gte.org/tengen/)"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title: 'Cancer du pancréas associé à d’autres tumeurs primitives',
        criteria: [
          Criterion(
            "Cancer du pancréas + au moins une des tumeurs primitives suivantes :",
            options: [
              "Cancer du sein infiltrant",
              "Adénocarcinome ovarien",
              "Mélanome malin",
              "Adénocarcinome prostate",
              "Cancer évocateur d'un syndrome de Lynch (cf. annexe 3)",
            ],
          ),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.theranostic,
        title: 'Situation théranostique (cancer isolé ou associé)',
        criteria: [
          Criterion(
              "Adénocarcinome biliopancréatique métastatique ou localement avancé quel que soit l’âge (enjeu potentiel d'une thérapie ciblée par inhibiteur de PARP si sensible aux sels de platine cf. AMM en vigueur)"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.familial,
        title: 'Antécédents familiaux',
        criteria: [
          Criterion(
              "3 cas d’adénocarcinome biliopancréatique dans la même branche parentale quel que soit l’âge"),
          Criterion(
            "1 cas d’adénocarcinome biliopancréatique + 1 apparenté au 1er degré atteint de :",
            options: [
              "Cancer du sein infiltrant",
              "Adénocarcinome biliopancréatique",
              "Adénocarcinome ovarien",
              "Mélanome malin",
              "Adénocarcinome prostate",
              "Cancer évocateur d'un syndrome de Lynch (cf. annexe 3)",
            ],
          ),
          Criterion(
            "1 cas d’adénocarcinome biliopancréatique + 2 apparentés au 1er ou 2ème degré dans la même branche parentale quel que soit l’âge atteint de :",
            options: [
              "Cancer du sein infiltrant",
              "Adénocarcinome biliopancréatique",
              "Adénocarcinome ovarien",
              "Mélanome malin",
              "Adénocarcinome prostate",
              "Cancer évocateur d'un syndrome de Lynch (cf. annexe 3)",
            ],
          ),
        ],
        footnotes: ["A discuter si TIPMP associée"],
      ),
    ],
    references: [
      "INCA © Conduites à tenir devant des patients atteints d’adénocarcinome du pancréas / Thésaurus, septembre 2019",
      "NCCN Clinical Pratice Guidelines in Oncology. Version 2.2025.",
      "Neuzillet C, Gaujoux S, Williet N, Bachet JB, Bauguion L, Colson Durand L, Conroy T, Dahan L, Gilabert M, Huguet F, Marthey L, Meilleroux J, de Mestier L, Napoleon B, Portales F, Sa Cunha A, Schwarz L, Taieb J, Chibaudel B, Bouche O, Hammel P; Thesaurus National de Cancerologie Digestive (TNCD); Pancreatic cancer: French clinical practice guidelines for diagnosis, treatment and follow-up (SNFGE, FFCD, GERCOR, UNICANCER, SFCD, SFED, SFRO, ACHBT, AFC). Dig Liver Dis. 2018 Dec; 50(12):1257-1271. doi: 10.1016/j.dld.2018.08.008",
      "Pancreatic cancer : ESMO Clinical Practice Guideline for diagnosis, treatment and follow-up5 T. Conroy1,2 , P. Pfeiffer3 , V. Vilgrain4,5, A. Lamarca6, T. Seufferlein7, E. M. O’Reilly8 , T. Hackert9, T. Golan10, G. Prager11, K. Haustermans12, A. Vogel13 & M. Ducreux14, on behalf of the ESMO Guidelines Committee",
      "N Engl J Med 2019;381:317-27. DOI: 10.1056/NEJMoa1903387",
    ],
  );

  // -------------------------------------------------------------------------
  // 7. Cancer du côlon
  // -------------------------------------------------------------------------
  static const Pathology _colon = Pathology(
    id: 'colon',
    name: 'Cancer du côlon',
    icon: Icons.route,
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [
          Criterion(_mutationTumorale),
          Criterion(_dmmrMshA),
          Criterion(_dmmrMlhA),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title: 'Cancer du côlon isolé',
        criteria: [
          Criterion("Cancer du côlon ≤ 40 ans (pMMR ou dMMR ou indisponible)"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title: 'Cancer du côlon associé à d’autres tumeurs primitives',
        criteria: [
          Criterion(
              "Cancer colorectal et 1 autre tumeur liée au syndrome de Lynch (cf. annexe 3), dont le 1er diagnostiqué ≤ 50 ans"),
          Criterion(
              "Cancer colorectal et 2 autres tumeurs liées au syndrome de Lynch, quel que soit l'âge"),
        ],
        footnotes: [_adenomaRemark],
      ),
      CriteriaSection(
        kind: SectionKind.theranostic,
        title: 'Situation théranostique',
        statement: _noTheranostic,
      ),
      CriteriaSection(
        kind: SectionKind.familial,
        title: 'Antécédents familiaux',
        criteria: [
          Criterion(
              "1 cas de cancer colorectal + 2 apparentés au 1er degré dans la même branche parentale atteints de tumeurs évocatrices d’un syndrome de Lynch (cf. annexe 3) *"),
        ],
        footnotes: [_ageFootnoteSomatic, _adenomaRemark],
      ),
    ],
    references: [
      "Mao R, Krautscheid P, Graham RP, Ganguly A, Shankar S, Ferber M, Hegde M, ACMG Laboratory Quality Assurance Committee. Genetic testing for inherited colorectal cancer and polyposis, 2021 revision: a technical standard of the American College of Medical Genetics and Genomics (ACMG). Genet Med. 2022;24(4):725-737. doi:10.1016/j.gim.2021.12.010.",
      "National Comprehensive Cancer Network (NCCN). NCCN Clinical Practice Guidelines in Oncology (NCCN Guidelines®): Genetic/Familial High-Risk Assessment: Colorectal, Endometrial, and Gastric. Version 3.2024. Published October 31, 2024. Available at: https://www.nccn.org.",
      "Buisine MP, Bonadona V, Baert-Desurmont S, Bonnet D, Coulet F, Dhooge M, Saurin JC, Remenieras A, Bignon YJ, Caron O, De Pauw A, Colas C, Buecher B. La polypose associée à MUTYH : synthèse et actualisation des recommandations françaises établies en 2012 sous l'égide de l'Institut national du cancer (INCa). Bulletin du Cancer. 2020;107(5):586-600. doi:10.1016/j.bulcan.2020.02.004.",
      "Coupier I, Pujol P. Prédispositions héréditaires aux cancers gynécologiques. Gynecol Obstet Fertil. 2005;33(11):851-6. doi:10.1016/j.gyobfe.2005.09.017.",
    ],
  );

  // -------------------------------------------------------------------------
  // 8. Cancer de l'endomètre
  // -------------------------------------------------------------------------
  static const Pathology _endometre = Pathology(
    id: 'endometre',
    name: 'Cancer de l’endomètre',
    icon: Icons.female,
    notes: [
      "NB : pour les cancers de l’endomètre de type séreux de haut grade se référer au « cancer de l’ovaire ».",
    ],
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [
          Criterion(_mutationTumorale),
          Criterion(_dmmrMshA),
          Criterion(_dmmrMlhA),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title: 'Cancer de l’endomètre isolé',
        criteria: [
          Criterion("Cancer de l’endomètre ≤ 40 ans"),
          Criterion(
              "Suspicion d’un syndrome de Cowden (altérations constitutionnelles du gène PTEN, cf. annexe 2)"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title: 'Cancer de l’endomètre associé à d’autres tumeurs primitives',
        criteria: [
          Criterion(
              "Cancer de l’endomètre et 1 autre tumeur liée au syndrome de Lynch (cf. annexe 3), dont le 1er diagnostiqué ≤ 50 ans"),
          Criterion(
              "Cancer de l’endomètre et 2 autres tumeurs liées au syndrome de Lynch, quel que soit l'âge"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.theranostic,
        title: 'Situation théranostique',
        statement: _noTheranostic,
      ),
      CriteriaSection(
        kind: SectionKind.familial,
        title: 'Antécédents familiaux',
        criteria: [
          Criterion(
              "1 cas de cancer de l’endomètre + 2 apparentés au 1er degré dans la même branche parentale atteints de tumeurs évocatrices d’un syndrome de Lynch (cf. annexe 3) *"),
        ],
        footnotes: [_ageFootnoteSomatic, _adenomaRemark],
      ),
    ],
    references: [
      "Alexa M, Hasenburg A, Battista MJ. The TCGA Molecular Classification of Endometrial Cancer and Its Possible Impact on Adjuvant Treatment Decisions. Cancers (Basel). 2021 Mar 23;13(6):1478.",
      "Dominguez-Valentin M, Sampson JR,Seppälä TT et al. Cancer risks by gene, age, and gender in 6350 carriers of pathogenic mismatch repair variants: findings from the Prospective Lynch Syndrome Database. Genetics in Medicine, 2020;22:15-25.",
      "NCCN Clinical Practice Guideline in Oncology, Uterine Neoplasms, Version 1.2023",
      "Hodan et al. Genetic/Familial High-Risk Assessment: Colorectal, Endometrial, and Gastric, Version 3.2024, NCCN Clinical Practice Guidelines In Oncology. J Natl Compr Canc Netw. 2024 Dec;22(10):695-711",
      "Zhao S, Chen L, Zang Y, Liu W, Liu S, Teng F, Xue F, Wang Y. Endometrial cancer in Lynch syndrome. Int J Cancer. 2022 Jan 1;150(1):7-17.",
    ],
  );

  // -------------------------------------------------------------------------
  // 9. Cancer de l'estomac
  // -------------------------------------------------------------------------
  static const Pathology _estomac = Pathology(
    id: 'estomac',
    name: 'Cancer de l’estomac',
    icon: Icons.restaurant_outlined,
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [
          Criterion(_mutationTumorale),
          Criterion(_dmmrMshB),
          Criterion(_dmmrMlhB),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title: 'Cancer de l’estomac isolé',
        criteria: [
          Criterion("Cancer gastrique ≤ 35 ans"),
          Criterion(
              "Cancer gastrique diffus (CGD) ou anciennement en bague à chaton ≤ 50 ans"),
          Criterion(
              "Multiples foyers de CGD (sous forme de carcinome in situ ou de foci pagétoïdes)"),
          Criterion(
              "CGD quel que soit l’âge chez les personnes ayant des antécédents de fente labiale ou palatine"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title: 'Cancer de l’estomac associé à d’autres tumeurs primitives',
        criteria: [
          Criterion("Cancer gastrique diffus et cancer du sein lobulaire infiltrant"),
          Criterion(
              "Cancer gastrique ≤ 50 ans et au moins 1 autre tumeur du spectre étroit du syndrome de Lynch (cf. annexe 3)"),
          Criterion(
              "Cancer gastrique et 2 autres tumeurs liées au syndrome de Lynch, quel que soit l'âge"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.theranostic,
        title: 'Situation théranostique',
        statement: _noTheranosticGastric,
      ),
      CriteriaSection(
        kind: SectionKind.familial,
        title: 'Antécédents familiaux',
        criteria: [
          Criterion(
              "2 cas ou plus de cancer gastrique dans la même branche parentale, quel que soit l'âge, avec au moins un cancer gastrique diffus confirmé"),
          Criterion(
              "1 cas de cancer gastrique diffus + 1 apparenté au 1er degré avec fente labiale ou palatine"),
          Criterion(
              "1 cas de cancer gastrique diffus + 1 apparenté au 1er degré avec un cancer du sein lobulaire infiltrant"),
          Criterion(
              "1 cas de cancer gastrique + 2 apparentés au 1er degré dans la même branche parentale atteints de tumeurs évocatrices d’un syndrome de Lynch (cf. annexe 3) *"),
        ],
        footnotes: [_ageFootnoteSomatic],
      ),
    ],
    references: [
      "Fitzgerald RC, Hardwick R, Huntsman D, Carneiro F, Guilford P, Blair V, et al. Hereditary diffuse gastric cancer: updated consensus guidelines for clinical management and directions for future research. Gut. 2015;64(10):1211-21. doi: 10.1136/gutjnl-2015-310999.",
      "Blair VR, McLeod M, Carneiro F, Coit DG, D'Addario JL, van Dieren JM, et al. Hereditary diffuse gastric cancer: updated clinical practice guidelines. Lancet Oncol. 2020 Aug;21(8):e386-e397. doi: 10.1016/S1470-2045(20)30219-9.",
      "Fewings E, Mitchell G, Hargrave D, et al. Germline pathogenic variants in PALB2 and other cancer-predisposing genes in families with hereditary diffuse gastric cancer without CDH1 mutation: a whole-exome sequencing study. Lancet Gastroenterol Hepatol. 2018;3(5):378-388. doi:10.1016/S2468-1253(18)30079-7.",
      "National Comprehensive Cancer Network (NCCN). NCCN Clinical Practice Guidelines in Oncology (NCCN Guidelines®): Genetic/Familial High-Risk Assessment: Colorectal, Endometrial, and Gastric. Version 3.2024. Published October 31, 2024. Available at: https://www.nccn.org.",
    ],
  );

  // -------------------------------------------------------------------------
  // 10. Polypose
  // -------------------------------------------------------------------------
  static const Pathology _polypose = Pathology(
    id: 'polypose',
    name: 'Polypose',
    icon: Icons.bubble_chart_outlined,
    sections: [
      CriteriaSection(
        kind: SectionKind.clinical,
        title: 'Présentation clinique (cf. annexe 6)',
        criteria: [
          Criterion(
              "Nombre cumulé* de polypes adénomateux colorectaux (prouvés histologiquement) ≥ 15, quel que soit l'âge"),
          Criterion(
            "Nombre cumulé* de polypes adénomateux colorectaux (prouvés histologiquement) compris entre 5 et 14 et au moins 2 des critères suivants :",
            minRequired: 2,
            options: [
              "≥ 2 adénomes avancés (c’est-à-dire les adénomes villeux, adénomes en DHG, adénomes ≥ 10 mm, adénome festonné traditionnel, lésions festonnées dysplasiques, lésions festonnées ≥ 10 mm)",
              "Tous les adénomes survenus à un âge ≤ 50 ans",
              "Diagnostic de cancer colorectal à un âge ≤ 60 ans",
              "Diagnostic d’un cancer du spectre du syndrome de Lynch (extra-colorectal)",
              "Diagnostic d’un adénome ou adénocarcinome duodénal ou ampullaire",
              "Polypose gastrique glandulo-kystique profuse",
              "Lésions sébacées multiples",
              "Consanguinité",
            ],
          ),
          Criterion("Polypose adénomateuse gastrique"),
          Criterion(
            "Polypose avec des antécédents personnels de :",
            options: [
              "Tumeur desmoïde",
              "Hépatoblastome",
              "CHRPE unilatérale",
              "Ostéome",
              "Kystes épidermoïdes",
            ],
          ),
          Criterion(
              "Phénotype clinique évocateur d'un syndrome de Peutz-Jeghers (cf. annexe 7), d'une polypose juvénile (cf. annexe 8) ou d'une maladie de Cowden (cf. annexe 2)"),
          Criterion(
              "Hypertrophie congénitale multifocale/bilatérale de l'épithélium pigmentaire rétinien (CHRPE)"),
        ],
        footnotes: ["*A l’occasion d’une ou de plusieurs coloscopies successives"],
      ),
    ],
    references: [
      "Mao R, Krautscheid P, Graham RP, Ganguly A, Shankar S, Ferber M, Hegde M, ACMG Laboratory Quality Assurance Committee. Genetic testing for inherited colorectal cancer and polyposis, 2021 revision: a technical standard of the American College of Medical Genetics and Genomics (ACMG). Genet Med. 2022;24(4):725-737. doi:10.1016/j.gim.2021.12.010.",
      "National Comprehensive Cancer Network (NCCN). NCCN Clinical Practice Guidelines in Oncology (NCCN Guidelines®): Genetic/Familial High-Risk Assessment: Colorectal, Endometrial, and Gastric. Version 3.2024. Published October 31, 2024. Available at: https://www.nccn.org.",
      "Buisine MP, Bonadona V, Baert-Desurmont S, Bonnet D, Coulet F, Dhooge M, Saurin JC, Remenieras A, Bignon YJ, Caron O, De Pauw A, Colas C, Buecher B. La polypose associée à MUTYH : synthèse et actualisation des recommandations françaises établies en 2012 sous l'égide de l'Institut national du cancer (INCa). Bulletin du Cancer. 2020;107(5):586-600. doi:10.1016/j.bulcan.2020.02.004.",
      "Site internet : https://www.sfed.org/recommandations/polypose-festonnee-adaptation-des-recommandations-esge-2019-nccn-2024-bsg-2020-juin-2025/",
    ],
  );

  // -------------------------------------------------------------------------
  // 11. Cancer du rein
  // -------------------------------------------------------------------------
  static const Pathology _rein = Pathology(
    id: 'rein',
    name: 'Cancer du rein',
    icon: Icons.water_drop_outlined,
    sections: [
      CriteriaSection(
        kind: SectionKind.biological,
        title: _biologicalTitle,
        criteria: [
          Criterion(_mutationTumorale),
          Criterion("Cancer à cellules rénales SDH-déficient"),
          Criterion("Cancer à cellules rénales FH-déficient"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalIsolated,
        title:
            'Consultation d’oncogénétique recommandée chez une personne atteinte de cancer à cellules rénales devant 1 ou plusieurs des critères suivants',
        criteria: [
          Criterion("Tumeurs rénales multiples ou bilatérales"),
          Criterion("Cancer du rein à cellules claires ≤ 40 ans"),
          Criterion(
              "Cancer à cellules rénales toutes autres histologies que cellules claires ≤ 50 ans (cancer chromophobe / oncocytome, cancer tubulopapillaire)"),
          Criterion(
              "Cancer du rein + 1 apparenté atteint de cancer du rein au 1er ou 2ème degré"),
        ],
      ),
      CriteriaSection(
        kind: SectionKind.personalMulti,
        title:
            'Cancer du rein associé à d’autres manifestations personnelles ou familiales évocatrices d’un syndrome génétique',
        criteria: [
          Criterion(
            "Cancer rénal à cellules claires + signes évocateurs VHL (Von Hippel Lindau) :",
            options: [
              "Hémangioblastomes (système nerveux central / rétine)",
              "Kystes et tumeurs neuro endocrines pancréatiques",
              "Kystes rénaux",
              "Phéochromocytomes / paragangliomes / tumeurs du sac endolymphatique",
            ],
          ),
          Criterion(
              "Cancer à cellules rénales + paragangliomes / phéochromocytomes / GIST (SDHA, SDHB, SDHC, SDHD)"),
          Criterion(
            "Cancer à cellules rénales + signes évocateurs BAP1 :",
            options: [
              "Mélanome uvéal / Mélanomes cutanés",
              "Mésothéliome pleural ou péritonéal",
              "Tumeurs cutanées (carcinomes basocellulaires / Spitz tumeurs)",
            ],
          ),
          Criterion(
              "Cancer à cellules rénales + signes évocateurs PTEN (Maladie de Cowden) (cf. annexe 2)"),
          Criterion(
              "Cancer à cellules rénales + signes évocateurs TSC1 / TSC2 (Sclérose Tubéreuse de Bourneville) : Angiomyolipome / épilepsie / retard mental …"),
          Criterion(
            "Cancer rénal chromophobe / hybride oncocytique / oncocytome + signes évocateurs FLCN (syndrome BHD Birt-Hogg-Dubé) :",
            options: [
              "Fibrofolliculomes",
              "Pneumothorax / Kystes pulmonaires",
            ],
          ),
          Criterion(
            "Cancer à cellules rénales FH-déficient (anciennement cancer rénal papillaire de type 2) + signes évocateurs FH (syndrome HLRCC Hereditary Leiomyomatosis and Renal Cell Cancer) :",
            options: [
              "Léiomyomes utérins",
              "Léiomyomes cutanés",
            ],
          ),
        ],
      ),
    ],
    references: [
      "Verkarre V, Morini A, Denize T, Ferlicot S, Richard S.Hereditary kidney cancers: The pathologist's view in 2020. Ann Pathol. 2020 Apr;40(2):148-167. doi: 10.1016/j.annpat.2020.02.022.",
      "Site Internet du réseau Prédir : https://www.predir.org/",
    ],
  );

  // -------------------------------------------------------------------------
  // Annexes
  // -------------------------------------------------------------------------
  static const List<Annexe> annexes = [
    Annexe(
      number: 1,
      title: 'Critères personnels et/ou familiaux pour suspecter un syndrome de Li-Fraumeni (LFS)',
      blocks: [
        ParagraphBlock(
            "Critères issus de l’article : Assessing germline TP53 mutations in cancer patients: insights into Li‑Fraumeni syndrome and genetic testing guidelines. Hereditary Cancer in Clinical Practice (2025) 23:5. Danishevich A et al."),
        ParagraphBlock(
            "Les tumeurs du spectre Li-Fraumeni (LFS) sont : cancer du sein, sarcome des tissus mous, ostéosarcome, tumeur du système nerveux central, carcinome corticosurrénalien",
            emphasis: true),
        LabeledBlock([
          LabeledRow(
            'Recommandation 1',
            [
              Item(
                  "Présentation familiale : individu atteint d'une tumeur du spectre LFS avant 46 ans ET au moins un parent au premier ou au deuxième degré atteint d'une tumeur du spectre LFS avant 56 ans."),
              Item(
                  "Tumeurs primitives multiples : individu présentant plusieurs tumeurs, dont 2 tumeurs du spectre LFS, dont la première est survenue avant 46 ans, quels que soient les antécédents familiaux."),
              Item(
                  "Tumeurs rares : patient atteint d'un carcinome corticosurrénalien, d'un carcinome du plexus choroïde ou d'un rhabdomyosarcome de sous-type anaplasique embryonnaire, quels que soient les antécédents familiaux."),
              Item(
                  "Cancer du sein précoce : cancer du sein avant 31 ans, quels que soient les antécédents familiaux."),
            ],
            intro:
                "Tous les patients qui répondent aux « critères de Chompret » modifiés :",
            joiner: 'OU',
          ),
          LabeledRow(
            'Recommandation 2',
            [
              Item("Leucémie aiguë lymphoblastique (LAL) hypodiploïde."),
              Item("Médulloblastome inexpliqué par la maladie de Sonic Hedgehog."),
              Item("Ostéosarcome de la mâchoire."),
            ],
            intro: "Les enfants et les adolescents pour :",
            joiner: 'OU',
          ),
          LabeledRow(
            'Recommandation 3',
            [
              Item(
                  "Les patients qui développent une deuxième tumeur primitive, dans le champ de radiation d'une première tumeur du spectre LFS survenue avant 46 ans."),
            ],
          ),
          LabeledRow(
            'Recommandation 4',
            [
              Item(
                  "Les enfants atteints d'un cancer, quel qu'il soit, et issus de familles du sud et du sud-est du Brésil."),
            ],
          ),
        ]),
      ],
    ),
    Annexe(
      number: 2,
      title: 'Critères de tests pour le syndrome de Cowden',
      blocks: [
        ParagraphBlock("Liste établie par le NCCN en 2025"),
        BulletsBlock(
          title: 'Test à envisager chez',
          [
            Item(
                "Individu appartenant à une famille où ségrége un variant délétère du gène PTEN"),
            Item(
                "Patient avec antécédent personnel de syndrome de Bannayan-Riley-Ruvalcaba"),
            Item("Patient avec histoire personnelle de :", [
              "Maladie de Lhermitte-Duclos",
              "Trouble du spectre autistique et macrocéphalie",
              "Au moins 2 trichilemmomes (confirmés par biopsie)",
              "Au moins 2 critères majeurs (l’un de ces critères doit être la macrocéphalie)",
              "3 critères majeurs sans la macrocéphalie",
              "1 critère majeur et au moins 3 critères mineurs",
              "Au moins 4 critères mineurs",
            ]),
          ],
        ),
        TwoColsBlock(
          'Critères majeurs',
          [
            Item("Cancer du sein"),
            Item("Cancer de l’endomètre (épithélial)"),
            Item("Cancer folliculaire de la thyroïde"),
            Item("≥ 3 hamartomes ou ganglioneuromes gastro-intestinaux"),
            Item("Maladie de Lhermite-Duclos (adulte)"),
            Item("Macrocéphalie, ≥ 97% (58cm pour les femmes et 60cm pour les hommes)"),
            Item("Pigmentation maculaire du gland"),
            Item("Lésions cutanéomuqueuses :", [
              "≥ 3 Trichilemmomes (dont 1 au moins prouvé par biopsie)",
              "≥ 3 fosses kératosiques palmoplantaires et/ou papules hyperkératosiques acrales",
              "≥ 3 névromes mucocutanés",
              "≥ 3 Papillomes buccaux (en particulier sur la langue et les gencives) ou 1 confirmé par biopsie ou diagnostiqué par un dermatologue)",
            ]),
          ],
          'Critères mineurs',
          [
            Item("Trouble du spectre autistique"),
            Item("Cancer du côlon"),
            Item("≥ 3 acanthoses glycogéniques œsophagiennes"),
            Item("Déficience intellectuelle (i.e. QI < 75)"),
            Item("Carcinome rénal"),
            Item("Lipomatose testiculaire"),
            Item("Cancer papillaire ou folliculaire de la thyroïde"),
            Item("Lésions structurales de la thyroïde (adénomes, nodules, goitre)"),
            Item("Unique hamartome ou ganglioneurome gastro-intestinal"),
            Item("Anomalies vasculaires"),
          ],
        ),
      ],
    ),
    Annexe(
      number: 3,
      title: 'Syndrome de Lynch',
      blocks: [
        ParagraphBlock("Critères familiaux", emphasis: true),
        LabeledBlock([
          LabeledRow('Spectre étroit', [
            Item("Adénocarcinome colorectal"),
            Item("Carcinome endomètre (principalement les carcinomes endométrioïdes)"),
            Item("Adénocarcinome intestin grêle"),
            Item("Adénocarcinome du bassinet rénal"),
            Item("Adénocarcinome des voies urinaires excrétrices supérieures"),
          ]),
          LabeledRow('Spectre élargi', [
            Item("Cancer gastrique"),
            Item("Adénocarcinome biliopancréatique"),
            Item("Adénocarcinome ovarien"),
            Item("Glioblastome"),
            Item("Adénome et adénocarcinome sébacé"),
            Item("Kérathoacanthome"),
          ]),
          LabeledRow(
            'Critères d’Amsterdam II',
            [
              Item("Chez au moins 3 apparentés de la même branche parentale"),
              Item("Sur 2 générations successives"),
              Item("Apparentés entre eux au 1er degré"),
              Item("≥ 1 cas ≤ 50 ans"),
            ],
            intro: "Cancer du spectre étroit de Lynch :",
          ),
        ]),
      ],
    ),
    Annexe(
      number: 4,
      title: 'Arbres décisionnels : résultats somatiques en faveur d’un syndrome de Lynch',
      blocks: [
        ParagraphBlock(
            "Arbres décisionnels issus de l’article : Le Syndrome de Lynch et le gynécologue. Gynécologie-Obstétrique – n° 224, novembre 2024."),
        ImageBlock('assets/images/annexe4_endometre.png',
            "Arbre décisionnel pour les carcinomes de l’endomètre (IHC + biologie moléculaire)"),
      ],
    ),
    Annexe(
      number: 5,
      title: 'DICER1',
      blocks: [
        ParagraphBlock(
            "Indications de tests issues de l’article : DICER1-Related Tumor Predisposition: Identification of At-risk Individuals and Recommended Surveillance Strategies. Clin Cancer Res 2024;30:5681–92. Schultz KAP et al."),
        ImageBlock('assets/images/annexe5_dicer1.png',
            "Table 2 — Indications for germline DICER1 testing"),
      ],
    ),
    Annexe(
      number: 6,
      title: 'Polypose',
      blocks: [
        ParagraphBlock(
            "Critères d'indication issus de l’article : La polypose associée à MUTYH : synthèse et actualisation des recommandations françaises établies en 2012 sous l'égide de l'Institut national du cancer (INCa). Bulletin du Cancer. 2020;107(5):586-600. Buisine MP et al."),
        ImageBlock('assets/images/annexe6_polypose.png',
            "Algorithme d’indication d’analyse devant une polypose ou des polypes multiples"),
      ],
    ),
    Annexe(
      number: 7,
      title: 'Syndrome de Peutz-Jeghers',
      blocks: [
        ParagraphBlock(
            "Critères diagnostiques du syndrome de Peutz-Jeghers (variant pathogène constitutionnel mono-allélique du gène STK11)",
            emphasis: true),
        BulletsBlock([
          Item("≥ 2 polypes de Peutz-Jeghers"),
          Item("Association de ≥ 1 polype de Peutz-Jeghers et d’une lentiginose péri-orificielle."),
          Item("≥ 1 polype de Peutz-Jeghers dans un contexte d’antécédent familial de polype de Peutz-Jeghers"),
          Item(
              "≥ 1 polype de Peutz-Jeghers avec antécédent personnel ou chez un apparenté du 1er degré de tumeur du spectre du syndrome de Peutz-Jeghers : tumeur ovarienne des cordons sexuels avec tubules annelés (\"sex cord tumour with annular tubules\"), tumeur testiculaire à cellules de Sertoli, adénocarcinome bien différencié du col utérin (« adenoma malignum ») ; adénocarcinome pancréatique et carcinome mammaire"),
        ]),
        ParagraphBlock("Les polypes doivent être histologiquement prouvés"),
      ],
    ),
    Annexe(
      number: 8,
      title: 'Polypose juvénile',
      blocks: [
        ParagraphBlock(
            "Critères diagnostiques de la polypose juvénile (variant pathogène constitutionnel mono-allélique du gène BMPR1A ou du gène SMAD4)",
            emphasis: true),
        BulletsBlock([
          Item("≥ 5 polypes juvéniles colorectaux"),
          Item("≥ 2 polypes juvéniles de localisation extra-colorectale (estomac, intestin grêle)"),
          Item("≥ 1 polype juvénile du tube digestif avec antécédent(s) familial (aux) de polypes juvéniles."),
          Item(
              "≥ 1 polype juvénile du tube digestif et phénotype compatible avec une maladie de Rendu-Osler (évocateur d’un variant pathogène du gène SMAD4)."),
        ]),
        ParagraphBlock("Les polypes doivent être histologiquement prouvés"),
      ],
    ),
  ];
}
