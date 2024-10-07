import random
import hashlib

# تعریف مجموعه برای ذخیره هش ها و لیست برای ذخیره collision ها
hash_set = set()
collision_list = []

# تولید پیام تصادفی و تولید هش آن
message = str(random.randint(1, 1000000))
hash_value = hashlib.md5(message.encode()).hexdigest()

# بررسی برای وجود collision
if hash_value in hash_set:
    collision_list.append((message, hash_value))
else:
    hash_set.add(hash_value)

# تکرار کد بالا، برای تولید پیام‌ها و بررسی برای وجود collision
for i in range(10000):
    message = str(random.randint(1, 1000000))
    hash_value = hashlib.md5(message.encode()).hexdigest()
    if hash_value in hash_set:
        collision_list.append((message, hash_value))
    else:
        hash_set.add(hash_value)

# چاپ تمامی collision ها :)
if len(collision_list) > 0:
    print(f"{len(collision_list)} collisions found:")
    i=1
    for message, hash_value in collision_list:
        print(f"Message {i}: {message},  Hash {i}: {hash_value}")
        i=i+1

else:
    print("No collisions found.")
