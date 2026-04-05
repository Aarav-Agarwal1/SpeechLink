//
//  ProjectStructures.swift
//  SpeechLink
//
//  Created by Aarav Agarwal on 7/27/25.
//

import SwiftUI
import AVFoundation

struct ASLLetter: Identifiable {
    let id = UUID()
    let letter: String
    let description: String
}

// MARK: - Functions
func calcIsPhone(heightSizeClass: UserInterfaceSizeClass?, widthSizeClass: UserInterfaceSizeClass?) -> Int {
    
    if  widthSizeClass == .compact && heightSizeClass == .regular{
        return 1
    }
    else if widthSizeClass == .regular && heightSizeClass == .compact || widthSizeClass == .compact && heightSizeClass == .compact{
        //pro max+plus landscape || non pro-max landscape
        return 2
    }
    else {//ipad
        return 3
    }
}

func getWordArray() -> Array<String> {
    let wordArray = [
      "aardvark", "abacus", "abandon", "abbey", "abdomen", "ability", "abnormal", "aboard", "abolish", "abominable",
      "aboriginal", "abortion", "abound", "about", "above", "abridge", "abroad", "abrupt", "abscess", "absent",
      "absolute", "absorb", "abstract", "absurd", "abundance", "abuse", "abysmal", "academy", "accelerate", "accent",
      "accept", "access", "accident", "acclaim", "accommodate", "accompany", "accomplish", "accord", "accordion", "account",
      "accurate", "accuse", "ace", "ache", "achieve", "acid", "acorn", "acoustic", "acquaintance", "acquire",
      "acre", "across", "act", "action", "active", "actor", "actual", "acute", "adage", "adapt",
      "add", "addict", "addition", "address", "adequate", "adhere", "adjacent", "adjective", "adjust", "administer",
      "admire", "admission", "admit", "adolescent", "adopt", "adorable", "adore", "adorn", "adult", "advance",
      "advantage", "advent", "adventure", "adverb", "advertise", "advice", "advise", "aero", "aerobic", "aerodynamics",
      "affair", "affect", "affection", "afflict", "afford", "afloat", "afraid", "after", "again", "against",
      "age", "agency", "agenda", "agent", "aggravate", "aggression", "agile", "agitate", "ago", "agree",
      "agriculture", "ahead", "aid", "ailment", "aim", "air", "aisle", "ajar", "alabama", "alameda",
      "alarm", "alas", "alaska", "albatross", "album", "alchemy", "alcohol", "alert", "algebra", "alien",
      "alight", "align", "alike", "alive", "all", "allegation", "allegiance", "alley", "alliance", "allocate",
      "allow", "alloy", "allude", "allure", "ally", "almighty", "almost", "alms", "aloft", "alone",
      "along", "aloud", "alphabet", "already", "also", "alter", "alternate", "although", "altitude", "altogether",
      "aluminum", "alumni", "always", "amass", "amaze", "amazon", "ambassador", "amber", "ambiance", "ambition",
      "ambitious", "amble", "ambulance", "amen", "amend", "america", "amiable", "amid", "amigo", "amiss",
      "ammonia", "amnesia", "among", "amount", "ample", "amuse", "anachronism", "analogy", "analysis", "analyze",
      "anarchy", "anatomy", "ancestor", "anchor", "ancient", "and", "anecdote", "angel", "anger", "angle",
      "angry", "anguish", "animal", "animate", "anise", "ankle", "annex", "annihilate", "anniversary", "announce",
      "annoy", "annual", "annuity", "anonymous", "another", "answer", "ant", "antagonize", "antarctica", "antecedent",
      "anthem", "anthology", "anthropology", "anti", "antibiotic", "anticipate", "antidote", "antiquated", "antique", "antiquity",
      "antler", "antonym", "anxiety", "any", "apart", "apathy", "ape", "aperture", "apologize", "apology",
      "apostrophe", "appall", "apparatus", "apparel", "apparent", "appeal", "appear", "appease", "appendix", "appetite",
      "applaud", "apple", "appliance", "applicant", "application", "apply", "appoint", "appraise", "appreciate", "apprehend",
      "apprentice", "approach", "appropriate", "approve", "approximate", "apricot", "april", "apron", "apt", "aqua",
      "aquarium", "aquatic", "aqueduct", "arabian", "arbiter", "arbitrary", "arbor", "arc", "arcade", "arch",
      "archaic", "archbishop", "archer", "archetype", "architecture", "archive", "arctic", "ardent", "arduous", "area",
      "arena", "argue", "argument", "arid", "arise", "aristocrat", "arithmetic", "arkansas", "arm", "armada",
      "armadillo", "armageddon", "armoire", "armor", "army", "aroma", "around", "arouse", "arrange", "array",
      "arrest", "arrival", "arrive", "arrogant", "arrow", "art", "artery", "article", "articulate", "artifact",
      "artifice", "artist", "ascend", "ascertain", "ascetic", "ascribe", "ash", "ashamed", "ashore", "aside",
      "ask", "asleep", "aspect", "aspire", "aspirin", "ass", "assailant", "assassinate", "assault", "assemble",
      "assembly", "assert", "assess", "asset", "assign", "assist", "associate", "assume", "assurance", "assure",
      "asterisk", "asteroid", "astonish", "astound", "astray", "astronomy", "astute", "asylum", "at", "ate",
      "atheist", "athlete", "atlas", "atmosphere", "atom", "atrocious", "attach", "attack", "attain", "attempt",
      "attend", "attention", "attentive", "attic", "attire", "attitude", "attorney", "attract", "attribute", "auburn",
      "auction", "audacious", "audible", "audio", "audit", "audition", "auditorium", "augment", "august", "aura",
      "auspicious", "austere", "australia", "authentic", "author", "autobiography", "autocrat", "automat", "automobile", "autonomy",
      "autumn", "avail", "avalanche", "avarice", "avenue", "average", "averse", "aversion", "avert", "aviary",
      "aviation", "avid", "avoid", "await", "awake", "award", "aware", "awash", "away", "awe",
      "awesome", "awful", "awkward", "awl", "awn", "awning", "axe", "axiom", "axis", "axle",
      "aye", "azure", "babble", "babe", "baby", "bachelor", "back", "bacon", "bacterium", "bad",
      "badge", "badger", "badly", "bag", "baggage", "bail", "bait", "bake", "balance", "balcony",
      "bald", "baleful", "balk", "ball", "balloon", "ballot", "balm", "bamboo", "ban", "banana",
      "band", "bandage", "bandit", "bang", "banish", "bank", "banner", "banquet", "bantam", "baptize",
      "bar", "barbarian", "barbecue", "barber", "bard", "bare", "bargain", "barge", "bark", "barley",
      "barn", "barometer", "baron", "barracks", "barrel", "barren", "barrier", "barrister", "barrow", "barter",
      "base", "basement", "bashful", "basic", "basin", "basis", "basket", "basketball", "bass", "bastard",
      "bat", "batch", "bath", "bathe", "bathos", "baton", "battalion", "battery", "battle", "bawdy",
      "bay", "bayonet", "bazaar", "be", "beach", "beacon", "bead", "beak", "beam", "bean",
      "bear", "beard", "beast", "beat", "beautiful", "beauty", "because", "beckon", "become", "bed",
      "bedazzle", "bedeck", "bedlam", "bee", "beef", "been", "beer", "beetle", "before", "beg",
      "begin", "behalf", "behave", "behind", "behold", "being", "belch", "belief", "believe", "bell",
      "belligerent", "bellow", "belly", "belong", "below", "belt", "bemoan", "bench", "bend", "beneath",
      "beneficial", "benefit", "benevolent", "benign", "bent", "bereft", "beret", "berry", "berth", "beseech",
      "beset", "besides", "besiege", "best", "bestial", "bet", "betray", "better", "between", "bevel",
      "beware", "bewilder", "beyond", "bias", "bible", "bicycle", "bid", "bide", "big", "bigotry",
      "bile", "bilingual", "bill", "billion", "bin", "bind", "binge", "biology", "biopsy", "biped",
      "birch", "bird", "birth", "biscuit", "bishop", "bison", "bit", "bite", "bitter",
      "black", "bladder", "blade", "blame", "blank", "blanket", "blast", "blaze", "bleak", "bleed",
      "blemish", "blend", "bless", "blight", "blind", "blink", "bliss", "blister", "blitz", "blizzard",
      "bloat", "blob", "block", "blonde", "blood", "bloom", "blossom", "blot", "blouse", "blow",
      "blue", "bluff", "blunder", "blunt", "blur", "blush", "boar", "board", "boast", "boat",
      "bob", "body", "bog", "bogus", "bohemian", "boil", "bold", "bolster", "bolt", "bomb",
      "bombard", "bond", "bone", "bonfire", "bonnet", "bonus", "book", "boom", "boon", "boost",
      "boot", "booth", "border", "bore", "born", "borrow", "bosom", "boss", "botany", "bother",
      "bottle", "bottom", "boulder", "bounce", "bound", "bounty", "bout", "bow", "bowel", "bowl",
      "box", "boy", "boycott", "bra", "brace", "bracelet", "bracket", "brain", "brake", "branch",
      "brand", "brave", "brawl", "brawn", "brazen", "breach", "bread", "break", "breakdown", "breakfast",
      "breast", "breath", "breathe", "breed", "breeze", "brevity", "brew", "bribe", "brick", "bride",
      "bridge", "brief", "brigade", "bright", "brilliant", "brim", "brine", "bring", "brisk", "bristle",
      "brittle", "broad", "broadcast", "brochure", "broil", "broke", "broken", "bronze", "brooch", "brood",
      "brook", "broom", "brother", "brow", "brown", "browse", "bruise", "brunch", "brush", "brute",
      "bubble", "bucket", "buckle", "bud", "budge", "budget", "buff", "buffalo", "buffer", "buffet",
      "bug", "bugle", "build", "bulb", "bulge", "bulk", "bull", "bullet", "bullion", "bully",
      "bum", "bump", "bumpy", "bunch", "bundle", "bungalow", "bunk", "bunker", "bunny", "burden",
      "bureau", "burglar", "burial", "burn", "burrow", "burst", "bury", "bus", "bush", "business",
      "bust", "bustle", "busy", "but", "butcher", "butt", "butter", "butterfly", "button", "buy",
      "buzz", "by", "bye", "cab", "cabbage", "cabin", "cabinet", "cable", "cactus", "cadaver",
      "caddie", "cadence", "cafe", "cage", "cahoots", "cajole", "cake", "calamity", "calcium", "calculate",
      "calendar", "calf", "caliber", "call", "calm", "calmly", "calorie", "camel", "camera", "camp",
      "campaign", "campus", "can", "canal", "canary", "cancel", "cancer", "candid", "candidate", "candle",
      "candy", "cane", "cannon", "canon", "canopy", "canyon", "cap", "capability", "capable", "capacity",
      "cape", "capillary", "capital", "capitol", "caprice", "captain", "caption", "captivate", "captive", "capture",
      "car", "caravan", "carbohydrate", "carbon", "card", "cardiac", "cardinal", "care", "career", "careful",
      "caress", "cargo", "caricature", "carmine", "carnage", "carnal", "carnivore", "carol", "carpet", "carriage",
      "carry", "cart", "cartel", "cartilage", "cartoon", "carve", "cascade", "case", "cash", "cashier",
      "casino", "casket", "cast", "caste", "castle", "casual", "casualty", "cat", "cataclysm", "catalog",
      "catapult", "cataract", "catastrophe", "catch", "category", "cater", "cathedral", "catholic", "cattle", "caulk",
      "cause", "cauterize", "caution", "cautious", "cavalry", "cave", "cavity", "cease", "cedar", "ceiling",
      "celebrate", "celestial", "celibate", "cell", "cellar", "cello", "cement", "cemetery", "censor", "cent",
      "centennial", "center", "centigrade", "centimeter", "central", "century", "ceramic", "cereal", "cerebral", "ceremony",
      "certain", "certify", "cesspool", "chafe", "chagrin", "chain", "chair", "chairman", "chalice", "chalk",
      "challenge", "chamber", "champion", "chance", "change", "channel", "chaos", "chapel", "chapter", "char",
      "character", "charcoal", "charge", "charity", "charm", "charter", "chase", "chasm", "chaste", "chat",
      "chateau", "chatter", "chauffeur", "cheap", "cheat", "check", "cheek", "cheer", "cheese", "chef",
      "chemical", "chemist", "cherish", "cherry", "chess", "chest", "chestnut", "chew", "chicago", "chick",
      "chicken", "chief", "child", "chile", "chill", "chime", "chin", "china", "chip", "chirp",
      "chisel", "chocolate", "choice", "choir", "choke", "choose", "chop", "chore", "chorus", "christ",
      "chronic", "chronicle", "chrysanthemum", "chubby", "chunk", "church", "churn", "cigar", "cinder", "cinema",
      "cinnamon", "circle", "circuit", "circulate", "circumstance", "circus", "cite", "citizen", "city", "civil",
      "civilian", "civilize", "claim", "clamber", "clamor", "clamp", "clan", "clandestine", "clap", "clarify",
      "clarion", "clash", "clasp", "class", "classic", "classify", "clatter", "clause", "claw", "clay",
      "clean", "clear", "cleave", "cleft", "clench", "cleric", "clerk", "clever", "cliche", "click",
      "client", "cliff", "climate", "climax", "climb", "clinch", "cling", "clinic", "clip", "cloak",
      "clock", "clog", "close", "closet", "clot", "cloth", "clothe", "cloud", "clout", "clown",
      "club", "clue", "clump", "clumsy", "clutter", "coach", "coal", "coarse", "coast", "coat",
      "coax", "cobble", "cobra", "cocaine", "cock", "cocktail", "cocoa", "coconut", "cocoon", "code",
      "coerce", "coffee", "coffin", "cognac", "cognition", "cohabit", "cohere", "cohort", "coil", "coin",
      "coincide", "cold", "cole", "collaboration", "collapse", "collar", "colleague", "collect", "college", "collide",
      "collie", "colon", "colonel", "colony", "color", "colossal", "column", "coma", "comb", "combat",
      "combine", "come", "comedy", "comet", "comfort", "comic", "comma", "command", "commence", "commend",
      "comment", "commerce", "commission", "commit", "committee", "commodity", "common", "commotion", "communicate", "community",
      "compact", "companion", "company", "compare", "compartment", "compass", "compassion", "compatible", "compel", "compendium",
      "compensate", "compete", "competent", "compile", "complacent", "complain", "complement", "complete", "complex", "compliant",
      "complicate", "compliment", "comply", "compose", "compound", "comprehend", "compress", "comprise", "compromise", "compulsion",
      "compute", "comrade", "concave", "conceal", "concede", "conceive", "concentrate", "concept", "concern", "concert",
      "concession", "concise", "conclude", "concord", "concrete", "condemn", "condense", "condition", "condolence", "conduct",
      "confer", "confess", "confide", "confident", "confine", "confirm", "conflict", "conform", "confound", "confront",
      "confuse", "congenial", "congest", "congratulate", "congregate", "congress", "congruent", "conjecture", "connect", "conquer",
      "conscience", "conscious", "conscript", "consecrate", "consent", "consequence", "conserve", "consider", "consign", "consistent",
      "console", "consolidate", "conspicuous", "conspiracy", "constant", "constellation", "constitute", "constrain", "construct", "consult",
      "consume", "contact", "contagion", "contain", "contaminate", "contemplate", "contemporary", "contempt", "contend", "content",
      "contest", "context", "continent", "contingent", "continue", "contort", "contour", "contraband", "contract", "contradict",
      "contrary", "contrast", "contribute", "contrive", "control", "controversy", "convene", "convention", "converge", "converse",
      "convert", "convey", "convict", "convince", "convulsion", "cook", "cool", "cooperate", "coordinate", "copious",
      "copper", "copy", "coral", "cordial", "core", "cork", "corn", "corner", "coronation", "corpse",
      "corpus", "correct", "correlate", "correspond", "corridor", "corrupt", "corset", "cosmetic", "cosmic", "cosmos",
      "cost", "costume", "cottage", "cotton", "couch", "cough", "council", "counsel", "count", "counter",
      "country", "county", "couple", "courage", "course", "court", "courtesy", "cousin", "covenant", "cover",
      "cow", "coward", "cower", "coyote", "cozy", "crab", "crack", "cradle", "craft", "cram",
      "cramp", "crane", "crank", "crash", "crater", "crave", "crawl", "crazy", "creak", "cream",
      "create", "creature", "credence", "credit", "creed", "creek", "creep", "crescent", "crest", "crew",
      "crib", "cricket", "crime", "crimson", "cripple", "crisis", "crisp", "critic", "croak", "crocodile",
      "crop", "cross", "crouch", "crow", "crowd", "crown", "crucial", "crude", "cruel", "cruise",
      "crumb", "crumble", "crush", "crust", "cry", "crypt", "crystal", "cube", "cuckoo", "cucumber",
      "cuddle", "culprit", "cult", "culture", "culvert", "cunning", "cup", "curb", "cure", "curiosity",
      "curious", "curl", "currant", "currency", "current", "curse", "curt", "curtain", "curve", "cushion",
      "custody", "custom", "cute", "cutlass", "cycle", "cynic", "cynical", "cypress", "dabble", "dagger",
      "daily", "dainty", "dairy", "daisy", "dale", "damage", "damn", "damp", "dance", "danger",
      "dare", "dark", "darling", "darn", "dart", "dash", "data", "date", "daunt", "dawn",
      "day", "daze", "dazzle", "dead", "deadly", "deaf", "deal", "dear", "death", "debacle",
      "debar", "debase", "debate", "debauch", "debilitate", "debit", "debris", "debt", "decade", "decay",
      "decease", "deceive", "december", "decent", "deception", "decide", "decimal", "decipher", "decision", "deck",
      "declare", "decline", "decode", "decompose", "decorate", "decoy", "decrease", "decree", "dedicate", "deduce",
      "deduct", "deed", "deem", "deep", "deface", "default", "defeat", "defect", "defend", "defense",
      "defer", "defiance", "deficiency", "deficit", "define", "definite", "deflate", "deflect", "deform", "defray",
      "deft", "defunct", "defy", "degenerate", "degrade", "degree", "dehydrate", "deity", "delay", "delectable",
      "delegate", "delete", "deliberate", "delicate", "delicious", "delight", "delinquent", "delirious", "deliver", "deluge",
      "delusion", "delve", "demagogue", "demand", "demarcate", "demeanor", "demented", "demise", "democracy", "demolish",
      "demon", "demonstrate", "demure", "denial", "denote", "denounce", "dense", "density", "dentist", "deny",
      "depart", "depend", "depict", "deplore", "deport", "deposit", "depress", "deprive", "depth", "deputy",
      "derail", "derive", "descend", "describe", "desert", "deserve", "design", "desire", "desk", "desolate",
      "despair", "desperate", "despise", "despite", "destiny", "destitute", "destroy", "detach", "detail", "detain",
      "detect", "deter", "deteriorate", "determine", "detest", "detonate", "detour", "detriment", "develop", "deviate",
      "device", "devil", "devious", "devise", "devote", "devour", "devout", "dew", "dexterity", "diabolic",
      "diagnose", "diagram", "dial", "dialect", "dialogue", "diameter", "diamond", "diary", "dichotomy", "dictate",
      "dictionary", "die", "diet", "differ", "difficult", "diffuse", "dig", "digest", "digit", "dignity",
      "dilemma", "diligent", "dilute", "dim", "dimension", "diminish", "din", "dine", "dingy", "dinner",
      "dinosaur", "dioxide", "dip", "diploma", "dire", "direct", "director", "dirt", "disability", "disable",
      "disagree", "disappear", "disappoint", "disarm", "disarray", "disaster", "disbelief", "discern", "discharge", "disciple",
      "discipline", "disclaim", "disclose", "discomfort", "disconnect", "discord", "discount", "discourage", "discourse", "discover",
      "discreet", "discrepancy", "discretion", "discriminate", "discuss", "disdain", "disease", "disgrace", "disguise", "disgust",
      "dish", "dishearten", "disintegrate", "dislike", "dislocate", "dismal", "dismay", "dismiss", "disobey", "disorder",
      "disparage", "disparity", "dispatch", "dispense", "disperse", "displace", "display", "displeasure", "dispose", "disprove",
      "dispute", "disrupt", "dissipate", "dissonance", "distance", "distant", "distill", "distinct", "distort", "distract",
      "distress", "distribute", "district", "disturb", "ditch", "dive", "diverse", "divert", "divide", "divine",
      "division", "divorce", "dizzy", "do", "docile", "dock", "doctor", "doctrine", "document", "dodge",
      "dog", "dogma", "dolce", "doleful", "dollar", "dollop", "dolphin", "domain", "dome", "domicile",
      "dominate", "donation", "donkey", "donor", "doom", "door", "dormant", "dose", "double", "doubt",
      "down", "dozen", "drag", "dragon", "drain", "drama", "drastic", "draw", "dread", "dream",
      "dreary", "dress", "dribble", "drift", "drill", "drink", "drip", "drive", "droll", "drone",
      "droop", "drop", "drought", "drown", "drug", "drum", "drunk", "dry", "dubious", "duck",
      "due", "dug", "dull", "dumb", "dump", "dungeon", "dunk", "dupe", "duplicate", "durable",
      "duration", "dusk", "dust", "duty", "dwarf", "dwell", "dwindle", "dynamite", "dynasty", "eager",
      "eagle", "ear", "earl", "early", "earn", "earth", "earthen", "ease", "east", "easy",
      "eat", "ebb", "ebony", "eccentric", "echo", "eclipse", "eclectic", "economic", "ecstasy", "ecstatic",
      "eddy", "edge", "edible", "edict", "edit", "edition", "educate", "eel", "eerie", "efface",
      "effect", "effective", "efficient", "effort", "egg", "ego", "egregious", "eject", "elaborate", "elate",
      "elbow", "elder", "elect", "elegant", "element", "elephant", "elevate", "eleven", "elf", "eligible",
      "eliminate", "elite", "eloquent", "else", "elude", "emaciate", "emancipate", "embargo", "embark", "embarrass",
      "embellish", "embezzle", "emblem", "embody", "embrace", "embroider", "emerald", "emerge", "emergency", "emigrant",
      "emigrate", "eminent", "emotion", "empathy", "emperor", "emphasis", "empire", "employ", "empower", "empty",
      "emulate", "enable", "enact", "enchant", "encompass", "encore", "encounter", "encourage", "encroach", "end",
      "endanger", "endeavor", "endorse", "endow", "endure", "enemy", "energy", "enforce", "engage", "engine",
      "engineer", "engrave", "enhance", "enigma", "enjoy", "enlarge", "enlighten", "enlist", "enormous", "enough",
      "enrage", "enrich", "enroll", "ensue", "ensure", "entail", "enter", "enterprise", "entertain", "enthrall",
      "entice", "entire", "entitle", "entity", "entourage", "entrance", "entreat", "entrenched", "enumerate", "envelop",
      "envelope", "envy", "ephemeral", "epic", "episode", "epitome", "equal", "equate", "equilibrium", "equip",
      "equitable", "era", "eradicate", "erase", "erect", "err", "errand", "erratic", "erroneous", "error",
      "erudite", "erupt", "escalate", "escape", "escort", "especial", "espionage", "essay", "essence", "essential",
      "establish", "estate", "esteem", "eternal", "ether", "ethereal", "ethical", "ethnic", "etiquette", "eulogy",
      "euphemism", "euphoria", "evacuate", "evade", "evaluate", "evaporate", "eve", "even", "evening", "event",
      "ever", "every", "evict", "evidence", "evil", "evoke", "evolve", "exacerbate", "exact", "exaggerate",
      "exalt", "examine", "example", "exasperate", "excavate", "exceed", "excel", "except", "excerpt", "excess",
      "exchange", "excite", "exclaim", "exclude", "exclusive", "excrete", "excruciating", "excursion", "excuse", "execute",
      "exempt", "exercise", "exhale", "exhaust", "exhibit", "exile", "exist", "exit", "exodus", "exonerate",
      "exorbitant", "expand", "expanse", "expect", "expedite", "expel", "expend", "expense", "expert", "expire",
      "explain", "explicit", "explode", "exploit", "explore", "explosion", "export", "expose", "express", "exquisite",
      "extend", "extensive", "exterior", "external", "extinct", "extinguish", "extra", "extract", "extraordinary", "extravagant",
      "extreme", "extricate", "exult", "eye", "fable", "fabric", "fabulous", "face", "facet", "facility",
      "fact", "faction", "factor", "faculty", "fade", "fail", "faint", "fair", "fairy", "faith",
      "fake", "fall", "fallow", "false", "fame", "familiar", "family", "famine", "famous", "fan",
      "fancy", "fantastic", "fantasy", "far", "farce", "fare", "farm", "fascinate", "fashion", "fast",
      "fat", "fatal", "fate", "father", "fathom", "fatigue", "fault", "fauna", "favor", "favorite",
      "fear", "feast", "feat", "feather", "feature", "february", "federate", "fee", "feeble", "feed",
      "feel", "feign", "feint", "felicity", "feline", "fell", "fellow", "felt", "female", "feminine",
      "fen", "fence", "ferment", "fern", "ferocious", "ferry", "fertile", "fervor", "fester", "festival",
      "festive", "fete", "fetid", "feud", "fever", "few", "fiasco", "fib", "fiber", "fickle",
      "fiction", "fiddle", "fidelity", "fidget", "field", "fierce", "fiery", "fifteen", "fifth", "fifty",
      "fig", "fight", "figure", "file", "fill", "film", "filter", "filth", "fin", "final",
      "finance", "find", "fine", "finger", "finish", "fire", "firm", "first", "fish", "fissure",
      "fist", "fit", "fix", "fixture", "fizz", "flabbergast", "flabby", "flag", "flagrant", "flail",
      "flair", "flake", "flame", "flank", "flap", "flare", "flash", "flat", "flatter", "flaunt",
      "flavor", "flaw", "flee", "fleece", "fleet", "flesh", "flick", "flinch", "fling", "flint",
      "flip", "flirt", "float", "flock", "flog", "flood", "floor", "flora", "florid", "florist",
      "flounce", "flounder", "flour", "flourish", "flow", "flower", "flu", "fluent", "fluff", "fluid",
      "fluke", "flung", "flush", "fluster", "flute", "flutter", "fly", "foal", "foam", "focus",
      "foe", "fog", "foil", "fold", "foliage", "folk", "follow", "fond", "font", "food",
      "fool", "foot", "for", "forbid", "force", "forebode", "forecast", "foreclose", "forefather", "forego",
      "foreign", "foremost", "forest", "forever", "forfeit", "forge", "forget", "forgive", "fork", "form",
      "formal", "format", "former", "formidable", "formula", "forsake", "fort", "forte", "forth", "fortify",
      "fortitude", "fortnight", "fortunate", "fortune", "forty", "forum", "forward", "fossil", "foster", "foul",
      "found", "foundation", "founder", "fountain", "four", "fowl", "fox", "fraction", "fracture", "fragile",
      "fragment", "fragrant", "frail", "frame", "franchise", "frank", "frantic", "fraternal", "fraud", "fray",
      "freak", "free", "freedom", "freeze", "freight", "french", "frenzy", "frequent", "fresh", "fret",
      "friar", "friction", "friday", "friend", "fright", "fringe", "frisk", "fritter", "frivolous", "fro",
      "frock", "frog", "from", "front", "frost", "frown", "frozen", "fruit", "frustrate", "fry",
      "fuel", "fugitive", "fulcrum", "fulfill", "full", "fumble", "fume", "fun", "function", "fund",
      "funeral", "fungus", "funnel", "funny", "fur", "furious", "furnish", "furrow", "further", "fury",
      "fuse", "fusion", "fuss", "futile", "future", "gable", "gadget", "gaffe", "gag", "gaiety",
      "gain", "gait", "galaxy", "gale", "gall", "gallant", "gallery", "galley", "gallop", "gallows",
      "gamble", "game", "gang", "gape", "garage", "garb", "garbage", "garden", "garish", "garland",
      "garlic", "garment", "garnish", "garrison", "garrulous", "garter", "gas", "gash", "gasp", "gate",
      "gather", "gauge", "gaunt", "gauze", "gaze", "gear", "gee", "gem", "gender", "gene",
      "general", "generate", "generous", "genesis", "genetic", "genial", "genius", "genre", "gentle", "genuine",
      "geography", "geology", "geometry", "germ", "german", "germinate", "gesture", "get", "ghastly", "ghost",
      "giant", "giddy", "gift", "giggle", "gild", "gill", "gilt", "gimmick", "giraffe", "gird",
      "girl", "gist", "give", "glacial", "glacier", "glad", "glade", "glamour", "glance", "gland",
      "glare", "glass", "gleam", "glean", "glide", "glimmer", "glimpse", "glisten", "glitch", "glitter",
      "gloat", "globe", "gloom", "glory", "glossary", "glove", "glow", "glue", "glum", "glut",
      "gnarl", "gnash", "gnaw", "go", "goad", "goal", "goat", "gobble", "goblet", "god",
      "goggle", "gold", "gondola", "gone", "gong", "good", "goose", "gore", "gorge", "gorgeous",
      "gospel", "gossip", "gouge", "govern", "gown", "grab", "grace", "grade", "gradual", "graduate",
      "graft", "grain", "grand", "grant", "grape", "graph", "grasp", "grass", "grate", "grateful",
      "gratify", "gratis", "grave", "gravel", "gravity", "gravy", "gray", "graze", "grease", "great",
      "greed", "green", "greet", "gregarious", "grief", "grieve", "grim", "grin", "grind", "grip",
      "grit", "groan", "groom", "groove", "gross", "grotesque", "ground", "group", "grove", "grow",
      "grueling", "gruff", "grumble", "grunt", "guarantee", "guard", "guess", "guest", "guide", "guile",
      "guilt", "guilty", "guitar", "gulf", "gullible", "gum", "gun", "gush", "gust", "gut",
      "gutter", "guy", "gym", "habit", "habitat", "hack", "haggle", "hail", "hair", "half",
      "hall", "hallow", "hallucinate", "halt", "ham", "hamburger", "hammer", "hamper", "hand", "handicap",
      "handle", "handsome", "hang", "hanker", "happen", "happy", "harass", "harbor", "hard", "hardy",
      "hare", "hark", "harm", "harness", "harp", "harsh", "harvest", "hash", "hassle", "haste",
      "hat", "hatch", "hate", "haughty", "haul", "haunt", "haven", "havoc", "hawk", "hazard",
      "haze", "head", "heal", "health", "heap", "hear", "heart", "hearth", "heat", "heaven",
      "heavy", "hectic", "hedge", "heel", "heft", "height", "heir", "helical", "hell", "hello",
      "helmet", "help", "hemp", "hen", "hence", "herald", "herb", "herculean", "herd", "here",
      "heresy", "heritage", "hermit", "hero", "heroic", "herring", "hesitate", "hew", "hide", "hideous",
      "high", "hilarious", "hill", "hinder", "hinge", "hint", "hip", "hiss", "history", "hit",
      "hitch", "hive", "hoard", "hoarse", "hobble", "hobby", "hoe", "hog", "hoist", "hold",
      "hole", "holiday", "hollow", "holocaust", "holy", "home", "homage", "homeless", "honest", "honey",
      "honeymoon", "honor", "hood", "hoof", "hook", "hoop", "hoot", "hope", "horizon", "horn",
      "horrible", "horror", "horse", "hospital", "host", "hostage", "hostile", "hot", "hotel", "hour",
      "house", "hover", "how", "however", "howl", "hub", "huddle", "hue", "hug", "huge",
      "hull", "hum", "human", "humane", "humble", "humid", "humor", "hundred", "hunger", "hungry",
      "hunt", "hurl", "hurry", "hurt", "hustle", "hut", "hybrid", "hydro", "hypnosis", "hypocrisy",
      "hysteria", "ice", "icon", "idea", "ideal", "identical", "identify", "idiom", "idiot", "idle",
      "idol", "ignite", "ignoble", "ignorant", "ignore", "illegal", "illicit", "illuminate", "illusion", "illustrate",
      "image", "imaginary", "imagine", "imbalance", "imbecile", "imbibe", "imitate", "immaculate", "immanent", "immature",
      "immediate", "immense", "immerse", "immigrant", "imminent", "immobile", "immortal", "immune", "impact", "impartial",
      "impasse", "impeach", "imperfect", "imperial", "impetuous", "implant", "implement", "implicate", "implicit", "implode",
      "implore", "imply", "impolite", "import", "impose", "impossible", "impotent", "impoverish", "impress", "imprint",
      "imprison", "improve", "impudent", "impulse", "impunity", "in", "inane", "inaugurate", "incapable", "incense",
      "incentive", "incessant", "inch", "incident", "incisive", "incite", "incline", "include", "income", "incompetent",
      "incongruous", "increase", "incur", "indebted", "indecent", "indeed", "indefinite", "indent", "independent", "index",
      "indicate", "indict", "indifferent", "indigenous", "indignant", "indirect", "individual", "indolent", "indoor", "induce",
      "indulge", "industry", "inept", "inert", "inevitable", "infant", "infatuate", "infect", "infer", "inferior",
      "inferno", "infest", "infinite", "infirm", "inflame", "inflate", "inflict", "influence", "inform", "infraction",
      "infuriate", "infuse", "ingenious", "ingenuity", "ingest", "ingrained", "ingredient", "inhabit", "inhale", "inherent",
      "inherit", "inhibit", "inhuman", "initial", "initiate", "inject", "injure", "ink", "inland", "inmate",
      "inn", "innate", "innocent", "innovate", "inquire", "insane", "inscribe", "insect", "insecure", "insert",
      "inside", "insidious", "insight", "insignificant", "insist", "insolent", "inspect", "inspire", "install", "instance",
      "instant", "instinct", "institute", "instruct", "insult", "insurance", "intact", "integral", "integrate", "integrity",
      "intellect", "intend", "intense", "intent", "interact", "intercept", "intercourse", "interest", "interfere", "interior",
      "interject", "intermediate", "intermittent", "internal", "interpret", "interrogate", "interrupt", "intersect", "intervene", "intestine",
      "intimate", "intimidate", "into", "intolerant", "intoxicate", "intricate", "intrigue", "intrinsic", "introduce", "introvert",
      "intrude", "intuition", "inundate", "invade", "invalid", "invaluable", "invent", "invest", "investigate", "invincible",
      "invisible", "invite", "invoke", "involve", "iron", "ironic", "irony", "irrelevant", "irresponsible", "irritable",
      "irritate", "isolate", "issue", "it", "item", "itinerary", "ivory", "jabber", "jack", "jacket",
      "jail", "jam", "january", "jar", "jargon", "jaw", "jaywalk", "jazz", "jealous", "jeer",
      "jelly", "jeopardize", "jerk", "jest", "jet", "jewel", "jiggle", "job", "jock", "jog",
      "join", "joint", "joke", "jolt", "journal", "journey", "joy", "jubilant", "judge", "judicious",
      "juggle", "juice", "july", "jumble", "jump", "junction", "jungle", "junior", "junk", "juridical",
      "jurisdiction", "jury", "just", "justice", "justify", "juvenile", "keen", "keep", "kettle", "key",
      "kick", "kid", "kidnap", "kidney", "kill", "kind", "kindle", "king", "kingdom", "kiss",
      "kitchen", "kite", "kitten", "knack", "knee", "kneel", "knell", "knife", "knit", "knob",
      "knock", "knot", "know", "knowledge", "knuckle", "label", "labor", "labyrinth", "lace", "lack",
      "lament", "lamp", "land", "lane", "language", "languid", "lanky", "lantern", "lap", "lapse",
      "lard", "large", "larva", "larynx", "lash", "last", "latch", "late", "latter", "laugh",
      "launch", "launder", "lavish", "law", "lawn", "lawsuit", "lawyer", "lax", "lay", "lazy",
      "lead", "leaf", "league", "leak", "lean", "leap", "learn", "lease", "least", "leather",
      "leave", "lecture", "left", "leg", "legacy", "legal", "legend", "legion", "legislate", "legitimate",
      "leisure", "lemon", "lend", "length", "leniency", "lens", "leopard", "leper", "less", "lesson",
      "let", "lethal", "letter", "level", "lever", "levity", "levy", "lewd", "liability", "liable",
      "liberal", "liberate", "liberty", "library", "license", "lick", "lid", "lie", "life", "lift",
      "light", "like", "likewise", "limb", "limit", "limp", "line", "linear", "linger", "link",
      "lion", "lip", "liquid", "list", "listen", "literary", "literature", "lithe", "little", "live",
      "lizard", "load", "loaf", "loan", "loath", "loathe", "lob", "lobby", "lobe", "local",
      "locate", "lock", "lodge", "loft", "logic", "logistics", "loiter", "lone", "lonely", "long",
      "look", "loom", "loop", "loose", "lord", "lose", "loss", "lot", "loud", "lounge",
      "love", "low", "loyal", "loyalty", "lucid", "luck", "ludicrous", "lull", "lumber", "luminous",
      "lump", "lunar", "lunch", "lurch", "lure", "lurid", "lush", "lust", "luxuriate", "luxury",
      "lyric", "macabre", "machine", "mad", "madam", "magazine", "magic", "magistrate", "magnet", "magnificent",
      "magnify", "magnitude", "maid", "mail", "maim", "main", "majesty", "major", "make", "malice",
      "malignant", "mall", "mallet", "mammal", "man", "manage", "mandate", "mane", "manger", "mangle",
      "mania", "manifest", "manipulate", "manner", "manor", "mantle", "manual", "manufacture", "manuscript", "many",
      "map", "marble", "march", "mare", "margin", "marine", "marital", "mark", "market", "marriage",
      "marrow", "marry", "marsh", "martyr", "marvel", "masculine", "mask", "mass", "massacre", "massage",
      "massive", "master", "match", "mate", "material", "maternal", "mathematics", "matrix", "matter", "mature",
      "maul", "maximize", "maximum", "may", "maybe", "maze", "me", "meager", "meal", "mean",
      "meander", "meaning", "meantime", "measure", "meat", "mechanic", "medal", "media", "mediate", "meditate",
      "medium", "meek", "meet", "melancholy", "meld", "mellow", "melody", "melon", "melt", "member",
      "membrane", "memo", "memoir", "memory", "menace", "mend", "mental", "mention", "menu", "mercenary",
      "merchandise", "merchant", "mercy", "mere", "merge", "merit", "merry", "mesh", "mess", "message",
      "metal", "metaphor", "meteor", "method", "meticulous", "metropolis", "micro", "microphone", "microscope", "middle",
      "might", "migrate", "mild", "mile", "military", "milk", "mill", "million", "mimic", "mince",
      "mind", "mine", "mineral", "mingle", "mini", "minimum", "minister", "minor", "mint", "minus",
      "minute", "miracle", "mirage", "mire", "mirror", "miscellaneous", "mischief", "miserable", "misery", "misfortune",
      "mishap", "mislead", "miss", "missile", "mission", "mist", "mistake", "mistletoe", "mistress", "misunderstand",
      "mix", "moan", "mob", "mobile", "mock", "mode", "model", "moderate", "modern", "modest",
      "modify", "moist", "moisture", "molar", "mold", "mole", "molecule", "molest", "moment", "momentum",
      "monarch", "monday", "monetary", "money", "monk", "monkey", "monogram", "monologue", "monster", "month",
      "monument", "mood", "moon", "moral", "morbid", "more", "morning", "mortal", "mosaic", "mosque",
      "mosquito", "moss", "most", "mother", "motion", "motive", "mound", "mount", "mountain", "mourn",
      "mouse", "mouth", "move", "movie", "mow", "much", "mud", "muddle", "muff", "muffin",
      "muffle", "mug", "mulch", "mule", "multiply", "multitude", "mumble", "munch", "mundane", "municipal",
      "mural", "murder", "murky", "murmur", "muscle", "muse", "mushroom", "music", "musket", "must",
      "mutate", "mute", "mutter", "mutual", "muzzle", "myriad", "mysterious", "mystery", "myth", "nail",
      "naive", "naked", "name", "narrate", "narrow", "nasty", "nation", "native", "natural", "nature",
      "naught", "naughty", "naval", "navigate", "navy", "near", "neat", "necessary", "neck", "nectar",
      "need", "needle", "negative", "neglect", "negotiate", "neighbor", "neither", "nephew", "nerve", "nervous",
      "nest", "net", "neutral", "never", "new", "news", "next", "nibble", "nice", "niche",
      "nick", "night", "nimble", "nine", "nip", "nipple", "nitrogen", "noble", "nobody", "nod",
      "noise", "nomad", "nominate", "none", "nonchalant", "noncommittal", "noodle", "noon", "noose", "norm",
      "normal", "north", "nose", "nostalgia", "nostril", "not", "note", "notice", "notion", "notorious",
      "nought", "nourish", "novel", "novice", "now", "noxious", "nozzle", "nuance", "nuclear", "nude",
      "nudge", "nugget", "nuisance", "null", "numb", "number", "numerous", "nun", "nurse", "nut",
      "nutrition", "nuzzle", "oak", "oar", "oasis", "oath", "obdurate", "obey", "object", "oblige",
      "obliterate", "oblivious", "obnoxious", "obscene", "obscure", "observe", "obsolete", "obstacle", "obtain", "obtrude",
      "obvious", "occasion", "occupy", "occur", "ocean", "ochre", "octagon", "october", "odd", "odious",
      "odor", "of", "off", "offend", "offer", "office", "official", "offset", "ogre", "oil",
      "old", "olive", "omen", "ominous", "omit", "omnipotent", "on", "once", "one", "onion",
      "online", "only", "onus", "onward", "ooze", "opal", "opaque", "open", "opera", "operate",
      "opinion", "opponent", "opportune", "opposite", "oppress", "opt", "optic", "optimist", "option", "or",
      "oracle", "oral", "orange", "orbit", "orchestra", "ordain", "order", "ordinary", "organ", "organic",
      "organize", "orient", "original", "ornament", "orphan", "orthodox", "oscillate", "osprey", "other", "otherwise",
      "oust", "out", "outdoor", "outer", "outfit", "outing", "outlet", "outline", "outlook", "outrage",
      "outside", "outspoken", "outstanding", "oval", "oven", "over", "overbear", "overcast", "overcome", "overdue",
      "overflow", "overhaul", "overlap", "overlook", "overnight", "overrun", "oversee", "overt", "overthrow", "overwhelm",
      "owe", "own", "owner", "ox", "oyster", "pace", "pacific", "pacify", "pack", "package",
      "pact", "paddle", "pagan", "page", "pageant", "pail", "pain", "paint", "pair", "palace",
      "palatable", "pale", "palm", "paltry", "pamper", "pamphlet", "pan", "pancake", "pander", "pane",
      "panic", "panorama", "pant", "pantry", "paper", "parable", "parachute", "parade", "paradigm", "paradise",
      "paradox", "paragraph", "parallel", "paralyze", "paramount", "paranoia", "parasite", "parcel", "parch", "parchment",
      "pardon", "parent", "parish", "parishioner", "park", "parliament", "parody", "parrot", "parsley", "parson",
      "part", "partake", "partial", "particle", "particular", "partisan", "partition", "partner", "partridge", "pass",
      "passage", "passenger", "passion", "passive", "past", "pastime", "pastor", "pasture", "pat", "patch",
      "patent", "paternal", "path", "pathetic", "patience", "patient", "patio", "patriarch", "patriot", "patrol",
      "patron", "pattern", "paucity", "pause", "pave", "pawn", "pay", "peace", "peach", "peacock",
      "peak", "pear", "pebble", "peculiar", "pedal", "pedestal", "pedestrian", "peel", "peer", "pen",
      "penal", "penalty", "pencil", "pending", "penetrate", "penguin", "peninsula", "penitent", "penny", "pension",
      "pensive", "people", "pepper", "perceive", "percent", "perch", "percolate", "percussion", "perfect", "perfidious",
      "perform", "perfume", "perhaps", "peril", "perimeter", "period", "perish", "perjury", "permanent", "permeate",
      "permission", "permissive", "permit", "perplex", "persecute", "persevere", "persist", "person", "perspective", "persuade",
      "pertain", "pertinent", "peruse", "pervade", "pessimist", "pest", "pet", "petal", "petition", "petrify",
      "petroleum", "petty", "phantom", "phase", "pheasant", "phenomenon", "philosophy", "phobia", "phone", "photo",
      "phrase", "physical", "physician", "physics", "piano", "pick", "pickle", "picnic", "picture", "pie",
      "piece", "pier", "pierce", "piety", "pig", "pigeon", "pigment", "pile", "pilgrim", "pill",
      "pillar", "pilot", "pin", "pinch", "pine", "pink", "pinnacle", "pioneer", "pious", "pipe",
      "pirate", "pistol", "pit", "pitch", "pity", "pivot", "pizza", "place", "placid", "plague",
      "plain", "plaintiff", "plan", "planet", "plank", "plant", "plasma", "plaster", "plastic", "plate",
      "plateau", "platform", "plausible", "play", "plead", "pleasant", "please", "pleasure", "pledge", "plenitude",
      "plenty", "pliable", "plight", "plod", "plop", "plot", "plow", "plug", "plum", "plumb",
      "plump", "plunder", "plunge", "plural", "plus", "plush", "ply", "pneumonia", "pocket", "pod",
      "poem", "poet", "poetry", "point", "poise", "poison", "poke", "pole", "police", "policy",
      "polish", "polite", "political", "poll", "pollute", "pond", "ponder", "pony", "pool", "poor",
      "pop", "populace", "popular", "populate", "porcelain", "porch", "pore", "pork", "porous", "port",
      "porter", "portion", "portrait", "pose", "position", "positive", "possess", "possible", "post", "postpone",
      "posture", "pot", "potassium", "potato", "potent", "potential", "pouch", "pounce", "pound", "pour",
      "pout", "poverty", "powder", "power", "practical", "practice", "praise", "prank", "pray", "preach",
      "precaution", "precede", "precept", "precious", "precipice", "precise", "predict", "preface", "prefer", "prejudice",
      "premise", "premium", "prepare", "prescribe", "presence", "present", "preserve", "president", "press", "pressure",
      "prestige", "presume", "pretend", "pretty", "prevail", "prevent", "previous", "prey", "price", "pride",
      "priest", "primary", "prime", "primitive", "prince", "princess", "principal", "principle", "print", "prior",
      "priority", "prison", "private", "privilege", "prize", "probable", "probe", "problem", "procedure", "proceed",
      "process", "proclaim", "procrastinate", "procure", "prodigal", "produce", "profane", "profess", "profession", "professor",
      "profile", "profit", "profound", "profuse", "progress", "prohibit", "project", "proliferate", "prominent", "promise",
      "promote", "prompt", "prone", "pronounce", "proof", "propel", "propensity", "proper", "prophet", "propose",
      "prose", "prosecute", "prospect", "prosper", "protect", "protest", "proud", "prove", "provide", "province",
      "provision", "provoke", "prowl", "prudent", "prune", "pry", "psalm", "psychic", "public", "publish",
      "pudding", "puddle", "puff", "pull", "pulp", "pulpit", "pulse", "pump", "punch", "punctual",
      "punish", "puny", "pupil", "puppet", "purchase", "pure", "purgatory", "purge", "purify", "purple",
      "purpose", "purse", "pursue", "push", "put", "puzzle", "pyramid", "quack", "quadrant", "quail",
      "quaint", "quake", "qualify", "quality", "qualm", "quantity", "quarrel", "quarry", "quart", "quarter",
      "quartz", "quash", "quasi", "queen", "queer", "quell", "quench", "query", "quest", "question",
      "queue", "quick", "quid", "quiet", "quill", "quilt", "quintessence", "quit", "quite", "quiver",
      "quiz", "quota", "quote", "rabbit", "rabid", "race", "rack", "racket", "radiant", "radiate",
      "radical", "radio", "radish", "radius", "raffle", "raft", "rag", "rage", "raid", "rail",
      "rain", "rainbow", "raise", "rake", "rally", "ram", "ramble", "rampage", "rancid", "random",
      "range", "rank", "ransom", "rant", "rap", "rapid", "rapture", "rare", "rascal", "rash",
      "rasp", "rate", "rather", "ratify", "ratio", "rational", "rattle", "raucous", "rave", "raven",
      "ravage", "raw", "ray", "razor", "reach", "react", "read", "ready", "real", "realize",
      "realm", "reap", "rear", "reason", "rebel", "rebuild", "recall", "recede", "receipt", "receive",
      "recent", "recess", "recipe", "reciprocal", "recite", "reckless", "reckon", "reclaim", "recognize", "recoil",
      "recollect", "recommend", "reconcile", "recondite", "record", "recount", "recover", "recreation", "recruit", "rectify",
      "red", "redeem", "redolent", "reduce", "redundant", "reel", "refer", "refine", "reflect", "reform",
      "refrain", "refresh", "refuge", "refusal", "refuse", "refute", "regain", "regal", "regard", "regatta",
      "regime", "region", "register", "regret", "regular", "regulate", "rehearse", "reign", "rein", "reinforce",
      "reject", "rejoice", "relate", "relax", "release", "relent", "reliable", "relic", "relief", "relieve",
      "religion", "relinquish", "relish", "reluctant", "rely", "remain", "remark", "remedy", "remember", "remind",
      "remorse", "remote", "remove", "renaissance", "render", "renege", "renew", "renounce", "renovate", "rent",
      "repair", "repast", "repay", "repeal", "repeat", "repel", "repent", "replicate", "report", "repose",
      "reprehensible", "represent", "reprieve", "reprimand", "reproach", "reproduce", "repudiate", "repulsive", "reputable", "repute",
      "request", "require", "rescue", "research", "resemble", "resent", "reserve", "reservoir", "reside", "resign",
      "resilient", "resist", "resolve", "resort", "resource", "respect", "respite", "respond", "responsible", "rest",
      "restaurant", "restless", "restore", "restrain", "result", "resume", "resurrection", "retail", "retain", "retaliate",
      "retard", "reticent", "retire", "retort", "retreat", "retrieve", "return", "reveal", "revel", "revenge",
      "revenue", "revere", "reverence", "reverse", "review", "revise", "revolt", "revolution", "revolve", "reward",
      "rhetoric", "rhyme", "rhythm", "ribbon", "rich", "riddle", "ride", "ridge", "ridiculous", "rifle",
      "rift", "right", "rigid", "rim", "rind", "ring", "rinse", "riot", "rip", "ripe",
      "rise", "risk", "rite", "rival", "river", "road", "roam", "roar", "roast", "rob",
      "robe", "robin", "robust", "rock", "rod", "rogue", "role", "roll", "roman", "romance",
      "romantic", "roof", "room", "root", "rope", "roster", "rotate", "rotund", "rough", "round",
      "rouse", "route", "routine", "row", "royal", "rub", "rubber", "rubbish", "rude", "rudiment",
      "ruffle", "rug", "ruin", "rule", "rumble", "ruminate", "rummage", "rumor", "run", "ruse",
      "rush", "rust", "rustic", "rustle", "rut", "sable", "sabotage", "sack", "sacred", "sacrifice",
      "sad", "saddle", "safe", "sag", "sage", "sail", "saint", "sake", "salad", "salary",
      "sale", "salient", "saloon", "salt", "salute", "salvage", "salvation", "same", "sample", "sanctuary",
      "sanction", "sand", "sane", "sanguine", "sanity", "sap", "sarcasm", "sash", "sate", "sated",
      "satin", "satire", "satisfy", "saturate", "saturday", "sauce", "saunter", "savage", "save", "savor",
      "saw", "say", "scale", "scalpel", "scan", "scandal", "scarce", "scare", "scarf", "scatter",
      "scene", "scent", "schedule", "scheme", "schism", "scholar", "school", "science", "scoff", "scold",
      "scoop", "scope", "scorch", "score", "scorn", "scorpion", "scour", "scout", "scowl", "scramble",
      "scrap", "scrape", "scratch", "scream", "screen", "screw", "scribble", "script", "scrub", "scruple",
      "scrutinize", "scuffle", "sculpture", "scum", "scurry", "sea", "seal", "seamless", "search", "season",
      "seat", "secede", "seclude", "second", "secret", "section", "secure", "sedate", "sedentary", "seduce",
      "see", "seed", "seek", "seem", "seep", "segment", "segregate", "seize", "seldom", "select",
      "self", "sell", "semblance", "semester", "semi", "senate", "send", "senior", "sensation", "sense",
      "sensible", "sensitive", "sensory", "sent", "sentence", "sentiment", "separate", "september", "sepulcher", "sequel",
      "sequence", "serene", "serenity", "serial", "series", "serious", "serpent", "servant", "serve", "service",
      "session", "set", "settle", "seven", "several", "severe", "sew", "shabby", "shack", "shade",
      "shadow", "shaft", "shake", "shall", "shallow", "shame", "shape", "share", "sharp", "shatter",
      "shave", "shawl", "she", "shear", "shed", "sheep", "sheer", "sheet", "shelf", "shell",
      "shelter", "shepherd", "shield", "shift", "shine", "ship", "shirk", "shirt", "shiver", "shock",
      "shoe", "shoot", "shop", "shore", "short", "shoulder", "shout", "shove", "shovel", "show",
      "shower", "shred", "shrewd", "shriek", "shrimp", "shrink", "shroud", "shrub", "shrug", "shudder",
      "shuffle", "shun", "shut", "shy", "sick", "side", "sidewalk", "siege", "sieve", "sift",
      "sigh", "sight", "sign", "signal", "signature", "significant", "signify", "silent", "silhouette", "silk",
      "silly", "silver", "similar", "simple", "simplicity", "simulate", "simultaneous", "sin", "since", "sincere",
      "sing", "single", "singular", "sink", "sip", "sir", "sister", "sit", "site", "situation",
      "six", "size", "skeleton", "skeptic", "sketch", "skid", "skill", "skin", "skip", "skirt",
      "skull", "sky", "slack", "slain", "slam", "slander", "slap", "slash", "slate", "slaughter",
      "slave", "slavery", "slay", "sleep", "sleet", "sleeve", "slender", "slice", "slick", "slide",
      "slight", "slim", "slime", "sling", "slip", "slit", "sliver", "slope", "slot", "sloth",
      "slow", "slumber", "slump", "slur", "slush", "small", "smart", "smash", "smear", "smell",
      "smile", "smirk", "smoke", "smooth", "smother", "smudge", "snag", "snail", "snake", "snap",
      "snare", "snarl", "snatch", "sneak", "sneer", "sneeze", "sniff", "snip", "snob", "snore",
      "snorkel", "snort", "snout", "snow", "snub", "so", "soak", "soap", "soar", "sob",
      "sober", "soccer", "social", "society", "sock", "sod", "soda", "soft", "soil", "solar",
      "soldier", "sole", "solemn", "solicit", "solid", "solitude", "solo", "solution", "solve", "some",
      "somehow", "someone", "something", "sometimes", "somewhat", "son", "song", "soon", "sophisticated", "sordid",
      "sore", "sorrow", "sorry", "sort", "soul", "sound", "soup", "sour", "source", "south",
      "sovereign", "sow", "space", "spacious", "spade", "span", "spank", "spare", "spark", "sparkle",
      "sparrow", "sparse", "spasm", "speak", "spear", "special", "species", "specify", "specimen", "spectacle",
      "spectrum", "speculate", "speech", "speed", "spell", "spend", "sphere", "spice", "spider", "spike",
      "spill", "spin", "spiral", "spirit", "spit", "spite", "splash", "splendid", "splendor", "splinter",
      "split", "spoil", "spoke", "sponge", "sponsor", "spontaneous", "spoon", "sport", "spot", "sprawl",
      "spray", "spread", "spring", "sprinkle", "sprout", "spruce", "spur", "spurn", "spurt", "spy",
      "squabble", "squad", "squander", "square", "squash", "squat", "squeak", "squeeze", "squint", "stab",
      "stable", "stack", "staff", "stage", "stagger", "stain", "stair", "stake", "stale", "stall",
      "stamp", "stance", "stand", "staple", "star", "stare", "start", "starve", "state", "station",
      "statue", "status", "stay", "steadfast", "steady", "steal", "steam", "steel", "steep", "steer",
      "stellar", "stem", "stench", "step", "sterile", "sterling", "stern", "stew", "stick", "stiff",
      "stifle", "stigma", "still", "stimulate", "sting", "stink", "stint", "stir", "stitch", "stock",
      "stodgy", "stoic", "stoke", "stomach", "stone", "stool", "stoop", "stop", "store", "storm",
      "story", "stout", "stove", "straight", "strain", "strange", "strangle", "strap", "stratagem", "strategy",
      "stray", "streak", "stream", "street", "strength", "strenuous", "stress", "stretch", "strict", "stride",
      "strife", "strike", "string", "strip", "strive", "stroke", "stroll", "strong", "structure", "struggle",
      "stubborn", "stuck", "student", "study", "stuff", "stumble", "stump", "stun", "stunt", "stupendous",
      "stupid", "sturdy", "stutter", "style", "subdue", "subject", "sublime", "submerge", "submit", "subordinate",
      "subscribe", "subsequent", "subside", "substance", "subtle", "suburb", "subway", "succeed", "success", "succumb",
      "such", "suck", "sudden", "suffer", "sufficient", "sugar", "suggest", "suit", "sulfur", "sullen",
      "sully", "sum", "summarize", "summer", "summit", "summon", "sun", "sunday", "sundry", "super",
      "superb", "superficial", "superfluous", "superior", "supervise", "supper", "supplement", "supply", "support", "suppose",
      "suppress", "supreme", "sure", "surface", "surge", "surprise", "surrender", "surreptitious", "surrogate", "surround",
      "survey", "survive", "suspect", "suspend", "suspense", "sustain", "swagger", "swallow", "swamp", "swan",
      "swarm", "sway", "swear", "sweat", "sweep", "sweet", "swell", "swift", "swim", "swindle",
      "swing", "swirl", "switch", "swoop", "sword", "syllable", "symbol", "sympathy", "symphony", "symptom",
      "syndrome", "synonym", "syntax", "synthetic", "system", "tabernacle", "table", "tableau", "taboo", "tacit",
      "tack", "tactic", "tactful", "tail", "tailor", "take", "tale", "talent", "talk", "tall",
      "tame", "tan", "tangle", "tank", "tantrum", "tap", "tape", "tardy", "target", "tariff",
      "tarnish", "task", "taste", "tatter", "taunt", "tavern", "tax", "taxi", "tea", "teach",
      "team", "tear", "tease", "technical", "technique", "tedious", "teen", "telepathy", "telephone", "telescope",
      "tell", "temper", "temperament", "temperate", "tempest", "temple", "temporary", "tempt", "ten", "tenant",
      "tend", "tendency", "tender", "tenet", "tenor", "tense", "tension", "tent", "tenuous", "term",
      "terminate", "terrace", "terrible", "terrific", "terrify", "territory", "terror", "test", "testament", "testify",
      "text", "texture", "than", "thank", "that", "the", "theater", "theft", "their", "them",
      "theme", "then", "theory", "there", "therefore", "thermal", "these", "thesis", "they", "thick",
      "thief", "thigh", "thin", "thing", "think", "third", "thirsty", "this", "thorn", "thorough",
      "those", "though", "thought", "thousand", "threat", "threshold", "thrift", "thrill", "thrive", "throat",
      "throne", "throng", "throw", "thrust", "thumb", "thump", "thunder", "thursday", "thus", "tick",
      "ticket", "tickle", "tide", "tidy", "tie", "tiger", "tight", "tile", "till", "tilt",
      "timber", "time", "timid", "tin", "tinder", "tinge", "tinkle", "tiny", "tip", "tire",
      "tissue", "title", "to", "toast", "today", "toe", "together", "toil", "token", "tolerate",
      "toll", "tomahawk", "tomato", "tomb", "tomorrow", "ton", "tone", "tongue", "tonight", "too",
      "tool", "tooth", "top", "topic", "topsy", "torment", "torn", "torrent", "torture", "toss",
      "total", "totter", "touch", "tough", "tour", "toward", "towel", "tower", "town", "toxic",
      "toy", "trace", "track", "tract", "trade", "tradition", "traffic", "tragedy", "trail", "train",
      "trait", "traitor", "tramp", "tranquil", "transcend", "transfer", "transform", "transgress", "transient", "transition",
      "translate", "transmit", "transparent", "transpire", "transport", "trap", "trash", "travel", "tray", "treachery",
      "tread", "treason", "treasure", "treat", "treaty", "tree", "tremble", "tremendous", "trench", "trend",
      "trespass", "trial", "triangle", "tribe", "tributary", "tribute", "trick", "trickle", "trifle", "trim",
      "trio", "trip", "trite", "triumph", "trivial", "troll", "trophy", "troop", "truce", "truck",
      "true", "truly", "trunk", "trust", "truth", "try", "tuesday", "tug", "tumble", "tumor",
      "tuna", "tundra", "tune", "turban", "turbulent", "turf", "turn", "tusk", "tutor", "twelve",
      "twenty", "twice", "twig", "twilight", "twin", "twinkle", "twist", "two", "type", "typhoon",
      "typical", "tyranny", "ugly", "ultimate", "umbrella", "unanimous", "unassuming", "unaware", "uncommon", "unconscious",
      "undeniable", "under", "undergo", "understand", "undertake", "undo", "undulate", "unearth", "uneasy", "unemployed",
      "uneven", "unexpected", "unfair", "unfold", "unfortunate", "unhappy", "uniform", "unify", "union", "unique",
      "unit", "unite", "universe", "unjust", "unless", "unlike", "unlikely", "unlimited", "unlock", "unnerve",
      "unprecedented", "unravel", "unrest", "unruly", "unseen", "unsettle", "unstable", "unthinkable", "untidy", "until",
      "unusual", "unveil", "up", "upbeat", "uphold", "upon", "upper", "upright", "uproar", "upset",
      "upstairs", "upward", "urban", "urge", "urgent", "urinate", "use", "usual", "usurp", "utensil",
      "utmost", "utopia", "vacant", "vacate", "vaccine", "vacillate", "vague", "vain", "valiant", "valid",
      "valley", "valor", "valuable", "value", "vandal", "vanish", "vanity", "vapor", "variable", "variant",
      "variation", "various", "vary", "vase", "vast", "vault", "veer", "vegetable", "vehicle", "veil",
      "vein", "velocity", "velvet", "veneer", "venerable", "vengeance", "venom", "ventilate", "venture", "verbal",
      "verdict", "verge", "verify", "veritable", "versatile", "verse", "version", "vertical", "very", "vessel",
      "veteran", "veto", "via", "vibrate", "vice", "vicinity", "vicious", "victim", "victorious", "victory",
      "video", "view", "vigilant", "vigor", "vile", "village", "villain", "vindicate", "vine", "vinegar",
      "vintage", "violate", "violent", "violet", "violin", "virgin", "virtue", "virtuoso", "visible", "vision",
      "visit", "vital", "vivid", "vocal", "vogue", "voice", "void", "volatile", "volcano", "volume",
      "voluntary", "volunteer", "vortex", "vote", "vouch", "vow", "voyage", "vulgar", "vulnerable", "wacky",
      "wad", "wade", "wafer", "wage", "wail", "wait", "wake", "walk", "wall", "wallet",
      "wallow", "wan", "wand", "wander", "wane", "want", "war", "ward", "warehouse", "warm",
      "warn", "warp", "warrant", "warrior", "wash", "wasp", "waste", "watch", "water", "wave",
      "wax", "way", "weak", "wealth", "weapon", "wear", "weary", "weather", "weave", "web",
      "wed", "wedge", "wednesday", "wee", "weed", "week", "weep", "weigh", "weight", "weird",
      "welcome", "weld", "welfare", "well", "west", "wet", "whale", "what", "whatever", "wheat",
      "wheel", "when", "where", "wherever", "whether", "which", "while", "whimper", "whine", "whip",
      "whirl", "whisper", "whistle", "white", "who", "whole", "why", "wicked", "wide", "wield",
      "wife", "wild", "will", "willing", "wilt", "win", "wince", "wind", "window", "wine",
      "wing", "wink", "winner", "winter", "wipe", "wire", "wise", "wish", "wisp", "wit",
      "witch", "with", "withdraw", "withhold", "without", "witness", "woe", "wolf", "woman", "wonder",
      "wont", "wood", "wool", "word", "work", "world", "worm", "worry", "worse", "worship",
      "worst", "worth", "wound", "wow", "wrap", "wrath", "wreck", "wrench", "wrestle", "wretched",
      "wriggle", "wright", "wring", "wrist", "write", "wrong", "xenophobia", "yacht", "yank", "yard",
      "yawn", "year", "yearn", "yell", "yellow", "yes", "yesterday", "yet", "yield", "yoga",
      "yogurt", "yoke", "yolk", "you", "young", "your", "yourself", "youth", "yule", "yummy",
      "zeal", "zealous", "zebra", "zenith", "zero", "zest", "zig", "zilch", "zinc", "zing",
      "zip", "zodiac", "zombie", "zone", "zoo", "zoom"
    ]
    return wordArray
}

// MARK: - View Modifiers
struct ShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 10, x: -8, y: -8)
            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.3): Color.black.opacity(0.3), radius: 10, x: 8, y: 8)
    }
}

// MARK: - Enums
enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    @available(iOS 13.0, *)
    case soft
    @available(iOS 13.0, *)
    case rigid
    case selection
    case oldSchool
    
    public func vibrate() {
        switch self {
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        case .rigid:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

// MARK: - Views

struct BackButton: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "arrow.left")
                .resizable()
                .frame(width: 27, height: 20)
                .foregroundColor(colorScheme == .light ? .black : .white)
            Spacer()
        }
        .padding()
    }
}

struct TitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
    }
}

struct HelpButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .font(.subheadline)
            Spacer()
            Image(systemName: "chevron.forward")
        }
        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
    }
}

struct LearnButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    
    var lessonName: String
    var lessonNumber: Int
    var lessonDescription: String
    var lessonState: Int // 1 means not started, 2 means done
    var accuracy: Int
    
    //let brightGray = Color(red: 0.8, green: 0.8, blue: 0.8)
    let fadedGreen = Color(red: 0.42, green: 0.7, blue: 0.45)
    let fadedBlue = Color(red: 0.4, green: 0.55, blue: 0.73)
    
    
    
    var body: some View {
        HStack(alignment: .top) {
            VStack (alignment: .leading) {
                Text(lessonName)
                    .font(Font.custom("AvenirNext-Regular", size: 20))
                    .bold()
                Spacer()
                if accuracy != 0 && lessonState == 2 {
                    Text("Accuracy: \(accuracy)%")
                        .font(Font.custom("Copperplate", size: 20))
                }
                Spacer()
                HStack {
                    Text("Lesson \(lessonNumber)")
                        .font(Font.custom("AvenirNext-Regular", size: 20))
                    Spacer()
                    
                    Image(systemName: lessonState == 2 ? "checkmark.circle" : "play.circle")
                        .imageScale(.large)
                    
                }
            }
            .padding()
            .foregroundStyle(colorScheme == .dark ? .black : .white)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(lessonState == 2 ? fadedGreen : fadedBlue)
            )
            
            VStack(alignment: .leading) {
                Text(lessonDescription)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(Font.custom("AvenirNext-Regular", size: 16))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                HStack {
                    Spacer()
                    Text(lessonState == 1 ? "Start Now" : "Review")
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
                        .font(Font.custom("AvenirNext-Regular", size: 20))
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(lessonState == 2 ? fadedGreen : fadedBlue)
                        )
                }
                    
            }
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 15) // Create a rounded rectangle shape
                .stroke(lessonState == 2 ? fadedGreen : fadedBlue, lineWidth: 1) // Stroke the shape to form the border
        )
        .padding()
        
    }
}

struct SectionView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            Text(title)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.leading)
            if content != "" {
                Text(content)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            
        }
        .padding()
    }
}

struct FAQView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var question: String
    var answer: String
    @State var isExpanded: Bool = false
    
    var body: some View {
        Button(action: {
            isExpanded.toggle()
        }, label: {
            VStack(alignment: .leading) {
                Divider()
                HStack(alignment: .top) {
                    Text(question)
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding(.top, 8)
                }
                if answer != "" && isExpanded {
                    Text(answer)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                
            }
            .padding()
        })
        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
    }
}

struct ImageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var imageName: String
    var body: some View {
        Image(imageName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 150)            // fix height
            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
    }
}

struct FlashcardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var letter: String
    var description: String
    
    var body: some View {
        VStack {
            ImageView(imageName: letter)
            TitleView(title: letter)
            Text(description)
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? .black : .white)
                .modifier(ShadowModifier())
        )
    }
}


struct HomeButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    
    var title: String
    var systemImage: String
    var text: String
    var width: Double
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .padding(.leading)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 7)
                Text(text)
                    .font(.system(.body, design: .default))
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 7)
                
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? .black : .white)
                .modifier(ShadowModifier())
        )
    }
    
}



struct RegularButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String
    var body: some View {
        HStack{
            Text(text)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .font(.largeTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? .black : .white)
                .modifier(ShadowModifier())
        )
    }
}


