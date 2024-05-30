plan:
		terraform plan

init:
		terraform init

apply:
		terraform apply -auto-approve

destroy:
		terraform destroy -auto-approve

post:
		# shell equivalent: curl -i "$(terraform output -raw base_url)/hey/joe" -X POST -d '{"name":"joe"}' -H "Content-Type: application/json"
		BASE_URL="$(shell terraform output -raw base_url)"; curl -i "$$BASE_URL/hey/joe" -X POST -d '{"name":"joe"}' -H "Content-Type: application/json"

tail:
		# shell equivalent: aws logs tail "$(terraform output -raw log_group_name)" --region us-east-1 --follow
		LOG_GROUP="$(shell terraform output -raw log_group_name)"; aws logs tail "$$LOG_GROUP" --region us-east-1 --follow

#                                              ..77!:.                                                
#                                           .~?PG##BGP?7.                                             
#                                     .::::7J#@&PP5G#BB#P:                                            
#                                   .~?7!~!77P#&7PYP&B&#@P      :!??^           .. .^:!?77!^77^^.     
#                                 .!?7!JY7!~!7?PP7^!B55#Y^     !5PYGY:         .!!!??!~~?J?7YJYJ!7~.  
#                                 ~Y~7P5?~^^^~?YPJ?755!^:~~^~^ JBYYG7.      .~~~~!~!^:..Y57JY5?!~~7?: 
#                                 ~J^?P!~!!~~!!~^^~7Y55YY?!!!JP#Y~Y?J^      :^~?Y7!~:.::5J^7?!^::::~?:
#                                 ~Y^?P!~~!!7J7~~~^^~J5J77??YG##BJ??7:     :77J?7~^:.:~!PP~~?~^:...:!Y
#                                 ~5!7GJ~?5PP5YJ?JJ?77!^^^^^!5#G?!!:  .~!!!?7!~~^:...:~!G@BJ!^:.....^J
#                                 ~Y7~?P5YY55?Y55JY5Y??77!!~J&B#PJ~    ..^77JJ7~^:.:~!5#&G!~?!^:....!Y
#                                 ^?^7~~?JJ!^^^~7!^7P?7J??JJ5&&5!7J!.     :^^7Y7!~::^^?G#?:!7~^::::~J^
#                                 ^?:^!~^^^^^:..:!7^P^.:::::::YP7YGY:     .~!!~7~~^:..:^557JY57!~^7J: 
#                                 :?Y~:^^::::....~?^G?.       ?B55GY:        .!!!??!~^^:7J?75J5?7?!.  
#                              .^~:!GGJ!~^^^^^::~77JY~.       !PPYP?.        .....~^^!??7?7^?7~~..    
#                            .~?Y?^!7JBBP5YJ77?5PJ?~           :~~~.                  ...  . .        
#                            ^5YJ!:!??7JP#&BB##GP~^~~..                                               
#                          .?5J~!7.:~!7??G@GB@Y77?7^^^~^^..                                           
#                         ^?P7~:!Y7~^:^^!G@PP&Y??!^:...::^~~~.                                        
#                        ^PY!~^..^!7??JJYB@GG&J!~~~^^:^::..:!J~                                       
#                      .~PJ!:^.....:^~7JP&&G#&J??7~^^!~^^~::^J7                                       
#                   .~!YGY!:.:...:~7Y5Y?G@&PB@PJ777J?!^:~~::!Y7                                       
#                 .~?YYJ5!:...::~?5Y!:. ~B@7P@Y775BPJ7^~!^.^??.                                       
#                ~??!!~~?!:.::^?5Y~.     ~P~YY.  .!5?~~7~.:!J7                                        
#               ~J7~~^.~!~^^~7YJ~.         ..    .7!~77~::~!Y!                                        
#          :^:^7J7~^::.:^!?Y5J^                  .YJ7!^:.^^7?                                         
#         ^Y7~YP?~^:..:~7J5?^                    .Y?~:::!7^!~                                         
#         ~57~?PJ~..^!7?J7:                       :755YY5J                                            
#        .!5!^~JY?~!77?!:                         ^5Y77J?.                                            
#        ~5?^^:7!.::::^:....                     ^Y?~~!7: ..                                          
#   .....~57~~~?!^^^^^^^^^^^:::::...............:5Y~~!^^^~7~:~:                                       
# ::^^^^^~JJJJJ5?7~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~????J?7JJ7Y57:.                                     
# :^^^^^^^^~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~~~~~~~~^:.                                     
#  ....:.:...... ............:::::::::::::::::::::..:........ .                                       
