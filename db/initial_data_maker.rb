##
# Create insert statements for data
# Output to out.sql
##

$brands_num = 10
$categories_num = 10
$products_num = 200
$skus_per_product_num = 4

$descriptions = [
"Lori Bedletter draws a name out of a box to let the winner touch dangerous animals. Lori has lost both of her hands to dangerous animals. Jerry Seinfield appears and touches an animal. The winner is a little girl whose parents are deaf to her refusals to touch the dangerous animal.",
"A boy attempts to win a bear for his girlfriend in a carnival game, but a cruel carny repeatedly distracts the boy by doing such things as spraying him in the face with water, each time saying, \"I never said I wouldn't!\" When the boy finally wins the game, the prize is revealed to be a literal bear.",
"Lucy and Paul meet Reba, a famous country singer who runs over some roadkill.",
"A boy with a medical condition that makes him sound sarcastic all the time struggles talking to people, because they cannot tell if he is sarcastic or not.",
"From the creators of Bedazzle Zit, comes a new blemish remover: Guac-A-Mole, guacamole that you apply to your mole.",
"Strawberryland is threatened by aliens and Strawberry Shortbread, must protect everyone from the aliens in this trailer for Strawberry Shortbread Saves The Earth.",
"Boys at school compete to see who has the saggiest jeans. Dag Sagger comes with his pants on his knees and scares off the competition. Eventually, Sag Master Jake arrives with his pants down to his ankles and he and Dag Sagger fight it out.",
"An Italian restaurant called 'Garlic Garden' has bad service. Vito, the waiter, says the restaurant treats customers like family, but doesn't care about his customers and hates his Ma, while his Ma only tries to help the restaurant out.",
"A student named Oscar gets kicked out of school for bad behavior. He then takes on a disguise as a fake foreign exchange student to get away with doing bad things by saying that they are part of his culture. At the end of the sketch, he says he's going to get away with murder. Note: Tawni Hart's role as teacher Joanne, from Rufus: Kid with Excuses, reappears again in this sketch with her last name revealed.",
"Two little girls wish they could text like their big sister, but they are too young. Their fears are no more when they find a new doll called \"Lil' Texters\". Val repeats everything her friend says.",
"Three teenage band members, who write songs about hating parents, try to find a new member, but when he comes, they find out that his songs are about loving parents and hating teens.",
"Julia Peters hosts a show about her crush, Zach Feldman. She invites guests such as Jay Harrick, who sits next to Zach in class, and Zach's cleaning lady, Oxana Crofski, who thought she was there for a cleaning job.",
"Jack Sparrow falls in love with various types of birds. When Jack's family warns him that he can't fly, he gets scared of a cat and jumps out of the nest."]
$descriptions.each do |d| d.gsub!('"','\\"') end

$origins = ["Indonesia","China","United Kingdom","USA","Japan","India","German","France","Russia"]

$colors = ["Red","Blue","Green","Brown","Teal","Yellow","Black","White"]

$skus_letters = ["A","B","C","D","E","F","G","H"]

def get_rand_desc()
	return $descriptions[rand($descriptions.size())]
end

def get_rand_origin()
	return $origins[rand($origins.size())]
end

def get_rand_price()
	return rand() * (50.0 + rand(100).to_f)
end

def get_rand_color()
	return $colors[rand($colors.size)]
end

def get_sku_letter(ith)
	return $skus_letters[ith]
end

def create_brands
	for i in 0...$brands_num
		$file.write("insert into brands values (#{i+1},'brand_#{i}',now());\n")
	end
end

def create_categories
	for i in 0...$categories_num
		$file.write("insert into categories values (#{i+1},'category_#{i}',now());\n")
	end
end

def create_products
	for i in 0...$products_num
		rBrand = 1 + rand($brands_num)
		rCat = 1 + rand($categories_num)
		rDesc = get_rand_desc()
		rOrigin = get_rand_origin()
		price = get_rand_price()
		$file.write("insert into products values (#{i+1},\"product_#{i}\",#{rBrand},#{rCat},\"#{rDesc}\",\"#{rOrigin}\",1,#{price},now());\n")
	end
end

def create_skus
	for i in 0...$products_num
		for j in 0...$skus_per_product_num
			rColor = get_rand_color()	
			letter = get_sku_letter(j)
			amt = rand(100)
			
			$file.write("insert into skus values (#{i+1},\"#{letter}\",\"#{rColor}\",'',#{amt},NULL,1);\n")
		end
	end
end

def clear_all

	
	$file.write("delete from skus;\n")	
	$file.write("delete from products;\n")
	$file.write("delete from brands;\n")
	$file.write("delete from categories;\n")	
end

def main
	clear_all()
	create_brands()
	create_categories()
	create_products()
	create_skus()
	
	
end



###### Call main
$file = File.new("out.sql","w")
main()
$file.close