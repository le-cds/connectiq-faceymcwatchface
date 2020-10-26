"""Generates code and configuration files for indicators and meters based on the specifications in
   source/indicators.json and source/meters.json."""

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


def to_id(theme):
    """Returns an ID to be used whereever our theme is referenced."""

    return F"Theme{theme['index']}"


def to_constant_name(id):
    """Turns an ID into a constant name (snake and upper case)."""

    # See https://stackoverflow.com/questions/1175208/elegant-python-function-to-convert-camelcase-to-snake-case

    # Take care of capital letters followed by non-capitals (except at string start); precede with underscore.
    id = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', id)

    # Insert remaining required underscores
    id = re.sub('([a-z0-9])([A-Z])', r'\1_\2', id)

    return id.upper()


def to_color_variable(id):
    """Turns a color key into the corresponding variable name."""

    return F"gColor{id[0].upper()}{id[1:]}"


def to_color_value(color):
    """Turns a color value into the proper literal to be used in Monkey C."""

    if color[0] == "#":
        # Hexadecimals are written differently
        return F"0x{color[1:]}"
    else:
        # Everything else is assumed to be a color constant
        return F"Graphics.{color}"




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

    for theme in config["themes"]:
        for language_code in theme["languages"]:
            language_codes.add(language_code)
    
    return language_codes


def generate_string(theme, language_code, out_file):
    # Check if this item has a translation
    if not language_code in theme["languages"]:
        print(F"Theme {theme['index']} has no translation for {language_code}")
    else:
        print(F'    <string id="{to_id(theme)}">{theme["languages"][language_code]}</string>', file=out_file)



def generate_strings(config):
    """Generates language definitions for the given config."""

    for language_code in assemble_languages(config):
        dir_name = "resources"
        if language_code != "en":
            dir_name += F"-{language_code}"
        
        file_name = F"{dir_name}/strings/strings_themes.xml"
        print(F"Generating strings for language code {language_code}: {file_name}")
        
        with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
            print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
            print("<strings>", file=out_file)

            # We need to generate a string for each theme
            for theme in config["themes"]:
                generate_string(theme, language_code, out_file)

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

    file_name = F"resources/menu/settingsMenuThemeSelection.xml"
    print(F"Generating menus: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print(F'<menu2 id="SettingsMenuThemeSelection" title="@Strings.Theme">', file=out_file)

        for theme in sorted_by_localized_name(config["themes"]):
            theme_id = to_id(theme)
            print(F'    <menu-item id="{theme_id}" label="@Strings.{theme_id}" />', file=out_file)

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

    file_name = F"resources/settings/properties_themes.xml"
    print(F"Generating properties: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print("<properties>", file=out_file)

        # There's only a single property right now
        print('    <property id="Theme" type="number">0</property>', file=out_file)

        print('</properties>', file=out_file)


def generate_settings(config):
    """Generate settings files for the given configuration, including properly sorted value lists."""

    file_name = F"resources/settings/settings_themes.xml"
    print(F"Generating settings: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print("<settings>", file=out_file)
        print('    <setting propertyKey="@Properties.Theme" title="@Strings.Theme">', file=out_file)
        print('        <settingConfig type="list">', file=out_file)

        for theme in sorted_by_localized_name(config["themes"]):
            theme_id = to_id(theme)
            print(F'            <listEntry value="{theme["index"]}">@Strings.{theme_id}</listEntry>', file=out_file)

        print('        </settingConfig>', file=out_file)
        print('    </setting>', file=out_file)
        print('</settings>', file=out_file)



 #####                       
#     #  ####  #####  ###### 
#       #    # #    # #      
#       #    # #    # #####  
#       #    # #    # #      
#     # #    # #    # #      
 #####   ####  #####  ###### 

def generate_global_color_variables(config, out_file):
    """Generates variables that contain the current colors."""

    # We simply assume that all themes define the same color constants as the first
    for color_name in config["themes"][0]["colors"]:
        print(F"var {to_color_variable(color_name)};", file=out_file)
    
    print("", file=out_file)


def generate_constants(config, out_file):
    """Generates name-related constants and writes them to the given output file."""

    print(F"const THEME_COUNT = {len(config['themes'])};", file=out_file)
    print('const THEME_PROPERTY = "Theme";', file=out_file)
    print("", file=out_file)


def generate_name_constants(config, out_file):
    """Generates name-related constants and writes them to the given output file."""

    print(F"const THEME_NAMES = [", file=out_file)

    theme_strings = ',\n    '.join( [ F'"{to_id(theme)}"' for theme in config["themes"] ] )
    print(F"    {theme_strings}", file=out_file)

    print("];\n", file=out_file)


def generate_resource_map(config, out_file):
    """Generates arrays that will map drawable and behavior IDs to the string resource ID
       that contains the properly localized name."""
    
    # Generate resource map of the drawables
    print(F"const THEME_TO_STRING_RESOURCE = [", file=out_file)

    theme_resource = ',\n    '.join( [ F'Rez.Strings.{to_id(theme)}' for theme in config["themes"] ] )
    print(F"    {theme_resource}", file=out_file)

    print("];\n", file=out_file)


def is_valid(theme, config):
    """Checks whether the theme defines the same colors as the base theme at index 0."""

    base_color_keys = set(config["themes"][0]["colors"].keys())
    theme_color_keys = set(theme["colors"].keys())

    if base_color_keys != theme_color_keys:
        print(F"Theme {theme['index']} is missing colors: {base_color_keys - theme_color_keys}")
        return False
    else:
        return True


def generate_theme_code(theme, out_file):
    """Generates the code to set the color variables to the theme colors."""

    colors = theme["colors"]

    for color_key in colors:
        print(F"            {to_color_variable(color_key)} = {to_color_value(colors[color_key])};", file=out_file)


def generate_color_update_function(config, out_file):
    """Generates behavior factory functions."""
    
    print("/**", file=out_file)
    print(" * Sets our color variables with regard to the current theme.", file=out_file)
    print(" */", file=out_file)
    print(F"function updateColors()" + " {", file=out_file)
    print('    switch (Application.getApp().getProperty(THEME_PROPERTY)) {', file=out_file)
    
    # Output all themes
    for theme in config["themes"]:
        if is_valid(theme, config):
            print(F"        case {theme['index']}:", file=out_file)
            generate_theme_code(theme, out_file)
            print("            break;", file=out_file)
    
    # Default theme
    print("        default:", file=out_file)
    print("            // Reset invalid theme number and call this again", file=out_file)
    print('            Application.getApp().setProperty(THEME_PROPERTY, 0);', file=out_file)
    print('            updateColors();', file=out_file)

    print("    }", file=out_file)
    print("}\n", file=out_file)

                                                               
def generate_code(config):
    """Generates a file with a whole bunch of code that may come in handy."""

    file_name = F"source/generated/Themes.mc"
    print(F"Generating code: {file_name}")

    with open(file_name, mode="w", encoding="utf8", newline="\n") as out_file:
        print(F"// {GENERATED_FILE_WARNING}", file=out_file)
        print("", file=out_file)
        print("using Toybox.Application;", file=out_file)
        print("using Toybox.Graphics;", file=out_file)
        print("", file=out_file)
        print("module FaceyMcWatchface {", file=out_file)
        print(F"module Themes " + "{", file=out_file)
        print("", file=out_file)

        print("// Global color variables", file=out_file);
        generate_global_color_variables(config, out_file)

        print("// Number of themes", file=out_file);
        generate_constants(config, out_file)
        
        print("// Names used in all sorts of properties, settings, drawables...", file=out_file)
        generate_name_constants(config, out_file)
        
        print("// String resource IDs that belong to things. Use these to generate names in the UI.", file=out_file)
        generate_resource_map(config, out_file)

        generate_color_update_function(config, out_file)

        print("} }", file=out_file)




#     #                     #####                               
##   ##   ##   # #    #    #     #  ####  #####  # #####  ##### 
# # # #  #  #  # ##   #    #       #    # #    # # #    #   #   
#  #  # #    # # # #  #     #####  #      #    # # #    #   #   
#     # ###### # #  # #          # #      #####  # #####    #   
#     # #    # # #   ##    #     # #    # #   #  # #        #   
#     # #    # # #    #     #####   ####  #    # # #        #   

with open(F"source/themes.json") as json_file:
    config = json.load(json_file)

    # We will probably shuffle lists around, so remember the original order
    add_index_field(config["themes"])

    # Generate all the code we need
    generate_strings(config)
    generate_menus(config)
    generate_properties(config)
    generate_settings(config)
    generate_code(config)
