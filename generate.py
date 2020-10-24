import json
import re


GENERATED_FILE_WARNING = "This is a generated file. Do not edit manually or suffer the consequences..."




#     #                                        
#     # ##### # #      # ##### # ######  ####  
#     #   #   # #      #   #   # #      #      
#     #   #   # #      #   #   # #####   ####  
#     #   #   # #      #   #   # #           # 
#     #   #   # #      #   #   # #      #    # 
 #####    #   # ###### #   #   # ######  ####  

def add_index_field(items):
    """Adds an index field to all dictionaries in the given list of dictionaries."""

    for index, item in enumerate(items):
        item["index"] = index


def sorted_by_localized_name(items):
    """Returns a view on the given items that is sorted by their English language names."""

    return sorted(
        items,
        key=lambda item: item["languages"]["en"])


def to_file_name_suffix(config):
    """Generates the suffix to be used for output files."""

    return F"_{config['category'].lower()}s"


def to_drawable_id(config, id):
    """Generates an identifier to be used for the given drawable ID."""

    return F"{config['category']}{id}"


def to_behavior_id(config, id):
    """Generates an identifier to be used for the given behavior ID."""

    return F"{config['category']}Behavior{id}"


def item_with_id(items, id):
    """From the given list of items, returns the item with the given ID or None if there is... well... none."""

    for item in items:
        if item["id"] == id:
            return item
    else:
        return None


def to_constant_name(id):
    """Turns an ID into a constant name (snake and upper case)."""

    # See https://stackoverflow.com/questions/1175208/elegant-python-function-to-convert-camelcase-to-snake-case

    # Take care of capital letters followed by non-capitals (except at string start); precede with underscore.
    id = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', id)

    # Insert remaining required underscores
    id = re.sub('([a-z0-9])([A-Z])', r'\1_\2', id)

    return id.upper()




######                                                          
#     # #####    ##   #    #   ##   #####  #      ######  ####  
#     # #    #  #  #  #    #  #  #  #    # #      #      #      
#     # #    # #    # #    # #    # #####  #      #####   ####  
#     # #####  ###### # ## # ###### #    # #      #           # 
#     # #   #  #    # ##  ## #    # #    # #      #      #    # 
######  #    # #    # #    # #    # #####  ###### ######  ####  

def generate_drawables(config):
    """Generate the drawables for the given config."""

    file_name = F"resources/drawables/drawables{to_file_name_suffix(config)}.xml"
    print(F"Generating drawables: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print(F"<drawables>", file=out_file)

        # We need to generate a drawable for each behavior
        for behavior in config["behaviors"]:
            behaviorId = to_behavior_id(config, behavior["id"])
            print(F'    <bitmap id="{behaviorId}" filename="icon_Behavior{behavior["id"]}.png" />', file=out_file)

        print(F"</drawables>", file=out_file)




 #####                                      
#     # ##### #####  # #    #  ####   ####  
#         #   #    # # ##   # #    # #      
 #####    #   #    # # # #  # #       ####  
      #   #   #####  # #  # # #  ###      # 
#     #   #   #   #  # #   ## #    # #    # 
 #####    #   #    # # #    #  ####   ####  

def assemble_languages(config):
    """Assembles all language codes used in the given config."""

    # We always want English
    language_codes = { "en" }

    for drawable in config["drawables"]:
        for language_code in drawable["languages"]:
            language_codes.add(language_code)

    for behavior in config["behaviors"]:
        for language_code in behavior["languages"]:
            language_codes.add(language_code)
    
    return language_codes


def generate_string(item, item_id, language_code, out_file):
    # Check if this item has a translation
    if not language_code in item["languages"]:
        print(F"{item_id} has no translation for {language_code}")
    else:
        print(F'    <string id="{item_id}">{item["languages"][language_code]}</string>', file=out_file)



def generate_strings(config):
    """Generates language definitions for the given config."""

    for language_code in assemble_languages(config):
        dir_name = "resources"
        if language_code != "en":
            dir_name += F"-{language_code}"
        
        file_name = F"{dir_name}/strings/strings{to_file_name_suffix(config)}.xml"
        print(F"Generating strings for language code {language_code}: {file_name}")
        
        with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
            print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
            print("<strings>", file=out_file)

            # We need to generate a string for each drawable
            print("    <!-- Drawables -->", file=out_file)
            for drawable in config["drawables"]:
                drawableId = to_drawable_id(config, drawable["id"])
                generate_string(drawable, drawableId, language_code, out_file)

            print("", file=out_file)
            print("    <!-- Behaviors -->", file=out_file)
            for behavior in config["behaviors"]:
                behaviorId = to_behavior_id(config, behavior["id"])
                generate_string(behavior, behaviorId, language_code, out_file)

            print("</strings>", file=out_file)




#     #                             
##   ## ###### #    # #    #  ####  
# # # # #      ##   # #    # #      
#  #  # #####  # #  # #    #  ####  
#     # #      #  # # #    #      # 
#     # #      #   ## #    # #    # 
#     # ###### #    #  ####   ####  

def generate_menus(config):
    """Generates a selection menu for the available behaviors, sorted by English name."""

    file_name = F"resources/menu/settingsMenu{config['category']}Selection.xml"
    print(F"Generating menus: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print(F'<menu2 id="SettingsMenu{config["category"]}Selection" title="@Strings.{config["category"]}">', file=out_file)

        for behavior in sorted_by_localized_name(config["behaviors"]):
            behavior_id = to_behavior_id(config, behavior["id"])
            print(F'    <icon-menu-item id="{behavior_id}" label="@Strings.{behavior_id}" icon="@Drawables.{behavior_id}" />', file=out_file)

        print('</menu2>', file=out_file)




 #####                                            
#     # ###### ##### ##### # #    #  ####   ####  
#       #        #     #   # ##   # #    # #      
 #####  #####    #     #   # # #  # #       ####  
      # #        #     #   # #  # # #  ###      # 
#     # #        #     #   # #   ## #    # #    # 
 #####  ######   #     #   # #    #  ####   ####  

def generate_properties(config):
    """Generate property files for the given configuration, including proper default values."""

    file_name = F"resources/settings/properties{to_file_name_suffix(config)}.xml"
    print(F"Generating properties: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print("<properties>", file=out_file)

        for drawable in config["drawables"]:
            drawable_id = to_drawable_id(config, drawable["id"])
            default_behavior = item_with_id(config["behaviors"], drawable["defaultBehavior"])

            print(F'    <property id="{drawable_id}" type="number">{default_behavior["index"]}</property> <!-- {default_behavior["id"]} -->', file=out_file)

        print('</properties>', file=out_file)


def generate_settings_behvaior_list(config):
    """Generates the proper settingConfig for the behaviors in the given config."""

    result = '        <settingConfig type="list">\n'

    for behavior in sorted_by_localized_name(config["behaviors"]):
        behavior_id = to_behavior_id(config, behavior["id"])
        result += F'            <listEntry value="{behavior["index"]}">@Strings.{behavior_id}</listEntry>\n'
    
    result += '        </settingConfig>'

    return result


def generate_settings(config):
    """Generate settings files for the given configuration, including properly sorted value lists."""

    # We'll be writing the same behavior list a lot, so simply generate it once and paste it
    behavior_list = generate_settings_behvaior_list(config)

    file_name = F"resources/settings/settings{to_file_name_suffix(config)}.xml"
    print(F"Generating settings: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print("<settings>", file=out_file)

        for drawable in config["drawables"]:
            drawable_id = to_drawable_id(config, drawable["id"])

            print(F'    <setting propertyKey="@Properties.{drawable_id}" title="@Strings.{drawable_id}">', file=out_file)
            print(behavior_list, file=out_file)
            print('    </setting>', file=out_file)

        print('</settings>', file=out_file)




 #####                                                        
#     #  ####  #    #  ####  #####   ##   #    # #####  ####  
#       #    # ##   # #        #    #  #  ##   #   #   #      
#       #    # # #  #  ####    #   #    # # #  #   #    ####  
#       #    # #  # #      #   #   ###### #  # #   #        # 
#     # #    # #   ## #    #   #   #    # #   ##   #   #    # 
 #####   ####  #    #  ####    #   #    # #    #   #    ####  


def generate_count_constants(config, out_file):
    """Generates name-related constants and writes them to the given output file."""

    print(F"const {to_constant_name(config['category'] + 'Count')} = {len(config['drawables'])};", file=out_file)
    print(F"const {to_constant_name(config['category'] + 'BehaviorCount')} = {len(config['behaviors'])};", file=out_file)
    print("", file=out_file)


def generate_name_constants(config, out_file):
    """Generates name-related constants and writes them to the given output file."""

    # Generate the names of the drawables
    print(F"const {to_constant_name(config['category'] + 'Names')} = [", file=out_file)

    drawable_strings = ',\n    '.join( [ F'"{to_drawable_id(config, drawable["id"])}"' for drawable in config["drawables"] ] )
    print(F"    {drawable_strings}", file=out_file)

    print("];\n", file=out_file)

    # Generate the names of the behaviors
    print(F"const {to_constant_name(config['category'] + 'BehaviorNames')} = [", file=out_file)

    behavior_strings = ',\n    '.join( [ F'"{to_behavior_id(config, behavior["id"])}"' for behavior in config["behaviors"] ] )
    print(F"    {behavior_strings}", file=out_file)

    print("];\n", file=out_file)


def generate_enum_constants(config, out_file):
    """Generates enumeration-related constants and writes them to the given output file."""

    # Generate enumerations of the drawables
    print(F"enum /* {config['category'].upper()} */ " + "{", file=out_file)

    drawable_constants = ',\n    '.join( [ to_constant_name(to_drawable_id(config, drawable["id"])) for drawable in config["drawables"] ] )
    print(F"    {drawable_constants}", file=out_file)

    print("}\n", file=out_file)

    # Generate enumerations of the behaviors
    print(F"enum /* {config['category'].upper()}_BEHAVIORS */ " + "{", file=out_file)

    behavior_constants = ',\n    '.join( [ to_constant_name(to_behavior_id(config, behavior["id"])) for behavior in config["behaviors"] ] )
    print(F"    {behavior_constants}", file=out_file)

    print("}\n", file=out_file)


def generate_resource_map(config, out_file):
    """Generates arrays that will map drawable and behavior IDs to the string resource ID
       that contains the properly localized name."""
    
    # Generate resource map of the drawables
    print(F"const {to_constant_name(config['category'] + 'ToStringResource')} = [", file=out_file)

    drawable_resources = ',\n    '.join( [ F'Rez.Strings.{to_drawable_id(config, drawable["id"])}' for drawable in config["drawables"] ] )
    print(F"    {drawable_resources}", file=out_file)

    print("];\n", file=out_file)
    
    # Generate resource map of the behaviors
    print(F"const {to_constant_name(config['category'] + 'BehaviorToStringResource')} = [", file=out_file)

    behavior_resources = ',\n    '.join( [ F'Rez.Strings.{to_behavior_id(config, behavior["id"])}' for behavior in config["behaviors"] ] )
    print(F"    {behavior_resources}", file=out_file)

    print("];\n", file=out_file)


def generate_factories(config, out_file):
    """Generates behavior factory functions."""
    
    print("/**", file=out_file)
    print(" * Turns a behavior ID into an instance of the class that implements the behavior.", file=out_file)
    print(" */", file=out_file)
    print(F"function create{config['category']}Behavior(id)" + " {", file=out_file)
    print("    switch (id) {", file=out_file)
    
    for behavior in config["behaviors"]:
        behavior_id = to_behavior_id(config, behavior["id"])
        print(F"        case {to_constant_name(behavior_id)}:", file=out_file)
        print(F"            return new {behavior_id}();", file=out_file)

    print("    }", file=out_file)
    print("}\n", file=out_file)

                                                               
def generate_constants(config):
    """Generates a file with a whole bunch of constants that may come in handy."""

    file_name = F"source/generated/{(config['category'])}s.mc"
    print(F"Generating constants: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"// {GENERATED_FILE_WARNING}", file=out_file)
        print("", file=out_file)
        print("module FaceyMcWatchface {", file=out_file)
        print(F"module {config['category']}s " + "{", file=out_file)
        print("", file=out_file)

        print("// Number of things and behaviors", file=out_file);
        generate_count_constants(config, out_file)

        print("// Enumerations of available things and behaviors to index into the other arrays", file=out_file)
        generate_enum_constants(config, out_file)
        
        print("// Names used in all sorts of properties, settings, drawables...", file=out_file)
        generate_name_constants(config, out_file)
        
        print("// String resource IDs that belong to things. Use these to generate names in the UI.", file=out_file)
        generate_resource_map(config, out_file)

        generate_factories(config, out_file)

        print("} }", file=out_file)




#     #                     #####                               
##   ##   ##   # #    #    #     #  ####  #####  # #####  ##### 
# # # #  #  #  # ##   #    #       #    # #    # # #    #   #   
#  #  # #    # # # #  #     #####  #      #    # # #    #   #   
#     # ###### # #  # #          # #      #####  # #####    #   
#     # #    # # #   ##    #     # #    # #   #  # #        #   
#     # #    # # #    #     #####   ####  #    # # #        #   

# Our configuration files
config_files = [ "indicators", "meters" ]

for file in config_files:
    with open(F"source/{file}.json") as json_file:
        config = json.load(json_file)

        print(config["category"])

        # We will probably shuffle lists around, so remember the original order
        add_index_field(config["drawables"])
        add_index_field(config["behaviors"])

        # Generate all the code we need
        generate_drawables(config)
        generate_strings(config)
        generate_menus(config)
        generate_properties(config)
        generate_settings(config)
        generate_constants(config)
