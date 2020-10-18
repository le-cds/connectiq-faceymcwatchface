import json


GENERATED_FILE_WARNING = "This is a generated file. Do not edit manually or suffer the consequences..."




#     #                                        
#     # ##### # #      # ##### # ######  ####  
#     #   #   # #      #   #   # #      #      
#     #   #   # #      #   #   # #####   ####  
#     #   #   # #      #   #   # #           # 
#     #   #   # #      #   #   # #      #    # 
 #####    #   # ###### #   #   # ######  ####  

def to_file_name_suffix(config):
    """Generates the suffix to be used for output files."""

    return F"_{config['category'].lower()}s"


def to_drawable_id(config, id):
    """Generates an identifier to be used for the given drawable ID."""

    return F"{config['category']}{id}"


def to_behavior_id(config, id):
    """Generates an identifier to be used for the given behavior ID."""

    return F"{config['category']}Behavior{id}"




 #####                           #####                                                           
#     #  ####  #####  ######    #     # ###### #    # ###### #####    ##   ##### #  ####  #    # 
#       #    # #    # #         #       #      ##   # #      #    #  #  #    #   # #    # ##   # 
#       #    # #    # #####     #  #### #####  # #  # #####  #    # #    #   #   # #    # # #  # 
#       #    # #    # #         #     # #      #  # # #      #####  ######   #   # #    # #  # # 
#     # #    # #    # #         #     # #      #   ## #      #   #  #    #   #   # #    # #   ## 
 #####   ####  #####  ######     #####  ###### #    # ###### #    # #    #   #   #  ####  #    # 
                                                                                                  

def generate_drawables(config):
    """Generate the drawables for the given config."""

    with open(F"resources/drawables/drawables{to_file_name_suffix(config)}.xml", mode="w", encoding="utf8") as out_file:
        print(F"<!-- {GENERATED_FILE_WARNING} -->", file=out_file)
        print(F"<drawables>", file=out_file)

        # We need to generate a drawable for each behavior
        for behavior in config["behaviors"]:
            behaviorId = to_behavior_id(config, behavior["id"])
            print(F'    <bitmap id="{behaviorId}" filename="icon_{behaviorId}.png" />', file=out_file)

        print(F"</drawables>", file=out_file)




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

        # Generate all the code we need
        generate_drawables(config)
