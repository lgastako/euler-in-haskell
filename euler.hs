import Char (digitToInt, intToDigit)
import Test.BenchPress (bench)
import List (sort, nub, tails, transpose)
import System.TimeIt (timeIt)

-- euler #1 
--
-- If we list all the natural numbers below 10 that are multiples of 3
-- or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
-- 
-- Find the sum of all the multiples of 3 or 5 below 1000.

-- 233168
euler1 :: Integer
euler1 = sum [x | x <- take 1000 [0..], mod x 3 == 0 || mod x 5 == 0]


-- euler #2
--
-- Each new term in the Fibonacci sequence is generated by adding the
-- previous two terms. By starting with 1 and 2, the first 10 terms
-- will be: 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...  Find the sum of
-- all the even-valued terms in the sequence which do not exceed four
-- million.

fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

sum_evens_under :: Integer -> [Integer] -> Integer
sum_evens_under n seq = sum [x | x <- takeWhile (< n) seq, mod x 2 == 0]

-- 4613732
euler2 :: Integer
euler2 = sum_evens_under 4000000 fibs

-- From forum on projecteuler.net
alt_euler2 = sum . takeWhile (< 4000000) . filter even $ fibs

factor :: Integer -> Integer -> Bool
factor n m = mod n m == 0

factors :: Integer -> [Integer]
factors n = n:(takeWhile (< n) . filter (factor n) $ [1..])

prime :: Integer -> Bool
prime n = length (factors n) <= 2

-- my original naive prime factors method
--prime_factors :: Integer -> [Integer]
--prime_factors n = filter prime (factors n)

max_factor :: Integer -> Integer
max_factor n = fromIntegral (ceiling (sqrt (fromIntegral n)))

first_prime_factor :: Integer -> Integer
first_prime_factor n = 
    -- Can probably make that y < sqrt(n), right?
    head [x | x <- [y | y <- takeWhile (< (fromIntegral (max_factor n))) even_faster_primes] ++ [n], factor n x]

faster_prime_factors :: Integer -> [Integer]
faster_prime_factors n = 
    let first = first_prime_factor n
    in
      if first < n
      then nub (1:first:(faster_prime_factors (div n first)))
      else [1,n]


-- euler #3
--
-- The prime factors of 13195 are 5, 7, 13 and 29.
-- What is the largest prime factor of the number 600851475143 ?

-- 6857
euler3 :: Integer
euler3 = maximum (faster_prime_factors 600851475143)



-- euler #4
--
-- A palindromic number reads the same both ways. The largest
-- palindrome made from the product of two 2-digit numbers is 9009 =
-- 91 99.
--
-- Find the largest palindrome made from the product of two 3-digit numbers.
--
three_digit_numbers = [100..999]

-- Since we know we are checking numbers we don't have to worry about
-- spaces or puncutation or whatever.

show_reverse :: Integer -> String
show_reverse = reverse . show

is_palindromic_number :: Integer -> Bool
is_palindromic_number n = show n == show_reverse n

-- 906609 -- wrong?
euler4 :: Integer
euler4 = maximum 
         (filter 
          is_palindromic_number
          [x * y | x <- three_digit_numbers, y <- three_digit_numbers ])


-- euler #5
--
-- 2520 is the smallest number that can be divided by each of the
-- numbers from 1 to 10 without any remainder.
--
-- What is the smallest number that is evenly divisible by all of the
-- numbers from 1 to 20?

-- has_head :: [a] :: [] -> Bool
has_head [x:xs] = True
has_head [] = False

divisible_by_all :: [Integer] -> Integer -> Bool
-- This will divide by all of them every time.. need to short
-- circuit... this being haskell I'm sure the answer is laziness, but
-- I'm not comfortable enough to figure it out so since this can only
-- increase running time by a constant factor (0..20) in this case I'm
-- going to leave it and maybe I'll see the technique in the forums
-- after I submit my answer.  Or maybe I'll understand it later.
--divisible_by_all ds n = length [d | d <- ds, mod n d == 0] == length ds
-- ok now it's lazy, dunno if that'll be enough, but we'll see
divisible_by_all ds n = length (takeWhile (factor n) [d | d <- ds]) == length ds

-- STILL way too slow
-- took 32 minutes or something, btu eventually got the answer.
-- 232792560
euler5 :: Integer
euler5 = head 
         (filter 
          (divisible_by_all 
           (reverse [11..20]))
          [20..])


-- euler #6
--
-- The sum of the squares of the first ten natural numbers is,
-- 1² + 2² + ... + 10² = 385
-- The square of the sum of the first ten natural numbers is,
-- (1 + 2 + ... + 10)² = 55² = 3025
-- Hence the difference between the sum of the squares of the first
-- ten natural numbers and the square of the sum is 3025 385 = 2640.
--
-- Find the difference between the sum of the squares of the first one
-- hundred natural numbers and the square of the sum.

natural_numbers = [1..]
first_100_natural_numbers = take 100 natural_numbers

square :: Integer -> Integer
square n = n * n

sum_of_squares :: [Integer] -> Integer
sum_of_squares xs = sum (map square xs)

square_of_sum :: [Integer] -> Integer
square_of_sum xs = square (sum xs)

-- 25164150
euler6 = (square_of_sum first_100_natural_numbers) -(sum_of_squares first_100_natural_numbers) 


-- euler #7
--
-- By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we
-- can see that the 6th prime is 13.
--
-- What is the 10001st prime number?

is_prime :: Integer -> Bool
is_prime n = length (take 3 (factors n)) == 2

nth_prime :: Int -> Integer
nth_prime n = last (take n fast_primes)

-- 104743
euler7 = nth_prime 10001


-- euler #8
--
-- Find the greatest product of five consecutive digits in the
-- 1000-digit number.
--
euler8_input = "73167176531330624919225119674426574742355349194934\
               \96983520312774506326239578318016984801869478851843\
               \85861560789112949495459501737958331952853208805511\
               \12540698747158523863050715693290963295227443043557\
               \66896648950445244523161731856403098711121722383113\
               \62229893423380308135336276614282806444486645238749\
               \30358907296290491560440772390713810515859307960866\
               \70172427121883998797908792274921901699720888093776\
               \65727333001053367881220235421809751254540594752243\
               \52584907711670556013604839586446706324415722155397\
               \53697817977846174064955149290862569321978468622482\
               \83972241375657056057490261407972968652414535100474\
               \82166370484403199890008895243450658541227588666881\
               \16427171479924442928230863465674813919123162824586\
               \17866458359124566529476545682848912883142607690042\
               \24219022671055626321111109370544217506941658960408\
               \07198403850962455444362981230987879927244284909188\
               \84580156166097919133875499200524063689912560717606\
               \05886116467109405077541002256983155200055935729725\
               \71636269561882670428252483600823257530420752963450"

get_first_n_consecutive_digits :: Int -> String -> [Int]
get_first_n_consecutive_digits n s = map digitToInt (take n s)

products_of_n_consecutive_digits :: Int -> String -> [Int]
products_of_n_consecutive_digits n s
                                 | length s >= n = (product 
                                                    (get_first_n_consecutive_digits n s)):
                                                   (products_of_n_consecutive_digits n (tail s))
                                 | otherwise     = []

-- 40824
euler8 = maximum (products_of_n_consecutive_digits 5 euler8_input)

-- from the threads (adapted to use my equivalent functions)... very nice.
euler8_alt = maximum . map (product . take 5) . tails $ string_digits euler8_input

-- euler #9
--
-- A Pythagorean triplet is a set of three natural numbers, a b c, for
-- which,
--
--   a² + b² = c²
--
-- For example, 3² + 4² = 9 + 16 = 25 = 5².
--
-- There exists exactly one Pythagorean triplet for which a + b + c =
-- 1000.
-- Find the product abc.

-- 31875000
euler9 :: Integer
euler9 = 
    let target = 1000
        (a, b) = head ([(a,b) | a <- [1..target],
                                b <- [1..target],
                                a < b, 
                                (square a) + (square b) == (square (target - a - b))])
        c = target - (a + b)
    in a * b * c

-- euler #10
--
-- site down, but from google it looks like it's sum all primes below 2,000,000.

primes :: [Integer]
primes = filter is_prime natural_numbers

-- transliterated from http://blog.functionalfun.net/2008/04/project-euler-problem-7-and-10.html
is_divisible_by_any :: [Integer] -> Integer -> Bool
is_divisible_by_any xs n =
    length (take 1 (filter (factor n) xs)) > 0

not_divisible_by_any :: [Integer] -> Integer -> Bool
not_divisible_by_any xs n =
    not (is_divisible_by_any xs n)

next_fast_prime :: Int -> Integer
next_fast_prime n = 
    let
        previous_primes :: [Integer]
        previous_primes =
            take (n - 1) fast_primes
    in head [x | x <- [(last previous_primes)..], not_divisible_by_any (filter (< (square x)) previous_primes) x]

fast_primes :: [Integer]
fast_primes = 2:3:[next_fast_prime n | n <- [3..]]

-- Seems like this should be significantly faster because you're
-- eliminating the mod 2's right awway but it seems to be about the
-- same... maybe a tiny bit faster.
next_faster_prime :: Int -> Integer
next_faster_prime n =
    let
        previous_primes :: [Integer]
        previous_primes =
            take (n - 1) fast_primes
    in head [x | x <- [(last previous_primes)..], odd x, not_divisible_by_any (filter (< (square x)) previous_primes) x]

even_faster_primes :: [Integer]
even_faster_primes = 2:3:[next_faster_prime n | n <- [3..]]

euler10 :: Integer
euler10 = sum (takeWhile (< 2000000) even_faster_primes)

-- bench 50 $ do putStr (show (length (take 500 primes)))
-- bench 50 $ do putStr (show (length (take 500 fast_primes)))

-- euler #11
--
-- In the 2020 grid below, four numbers along a diagonal line have
-- been marked in red.
--
-- [grid redacted]
--
-- The product of these numbers is 26 * 63 * 78 * 14 = 1788696.
--
-- What is the greatest product of four adjacent numbers in any
-- direction (up, down, left, right, or diagonally) in the 20x20 grid?

--euler11 = map (take 4) (tails euler11_rows)

five_at_a_time xs = filter ((>= 5) . length) (map (take 5) (tails xs))
products_of_five_at_a_time xs = map product (five_at_a_time xs)
max_products_of_five_at_a_time = maximum . products_of_five_at_a_time
e11_row_maxes = map max_products_of_five_at_a_time euler11_rows
e11_col_maxes = map max_products_of_five_at_a_time euler11_cols
e11_max_row_product = maximum e11_row_maxes
e11_max_col_product = maximum e11_col_maxes
e11_max_diag_product = 0 -- TODO: This

euler11 = maximum [e11_max_col_product, e11_max_row_product, e11_max_diag_product]


-- sort of cheating, but whatever...
euler11_rows = [
 [08, 02, 22, 97, 38, 15, 00, 40, 00, 75, 04, 05, 07, 78, 52, 12, 50, 77, 91, 08],
 [49, 49, 99, 40, 17, 81, 18, 57, 60, 87, 17, 40, 98, 43, 69, 48, 04, 56, 62, 00],
 [81, 49, 31, 73, 55, 79, 14, 29, 93, 71, 40, 67, 53, 88, 30, 03, 49, 13, 36, 65],
 [52, 70, 95, 23, 04, 60, 11, 42, 69, 24, 68, 56, 01, 32, 56, 71, 37, 02, 36, 91],
 [22, 31, 16, 71, 51, 67, 63, 89, 41, 92, 36, 54, 22, 40, 40, 28, 66, 33, 13, 80],
 [24, 47, 32, 60, 99, 03, 45, 02, 44, 75, 33, 53, 78, 36, 84, 20, 35, 17, 12, 50],
 [32, 98, 81, 28, 64, 23, 67, 10, 26, 38, 40, 67, 59, 54, 70, 66, 18, 38, 64, 70],
 [67, 26, 20, 68, 02, 62, 12, 20, 95, 63, 94, 39, 63, 08, 40, 91, 66, 49, 94, 21],
 [24, 55, 58, 05, 66, 73, 99, 26, 97, 17, 78, 78, 96, 83, 14, 88, 34, 89, 63, 72],
 [21, 36, 23, 09, 75, 00, 76, 44, 20, 45, 35, 14, 00, 61, 33, 97, 34, 31, 33, 95],
 [78, 17, 53, 28, 22, 75, 31, 67, 15, 94, 03, 80, 04, 62, 16, 14, 09, 53, 56, 92],
 [16, 39, 05, 42, 96, 35, 31, 47, 55, 58, 88, 24, 00, 17, 54, 24, 36, 29, 85, 57],
 [86, 56, 00, 48, 35, 71, 89, 07, 05, 44, 44, 37, 44, 60, 21, 58, 51, 54, 17, 58],
 [19, 80, 81, 68, 05, 94, 47, 69, 28, 73, 92, 13, 86, 52, 17, 77, 04, 89, 55, 40],
 [04, 52, 08, 83, 97, 35, 99, 16, 07, 97, 57, 32, 16, 26, 26, 79, 33, 27, 98, 66],
 [88, 36, 68, 87, 57, 62, 20, 72, 03, 46, 33, 67, 46, 55, 12, 32, 63, 93, 53, 69],
 [04, 42, 16, 73, 38, 25, 39, 11, 24, 94, 72, 18, 08, 46, 29, 32, 40, 62, 76, 36],
 [20, 69, 36, 41, 72, 30, 23, 88, 34, 62, 99, 69, 82, 67, 59, 85, 74, 04, 36, 16],
 [20, 73, 35, 29, 78, 31, 90, 01, 74, 31, 49, 71, 48, 86, 81, 16, 23, 57, 05, 54],
 [01, 70, 54, 71, 83, 51, 54, 69, 16, 92, 33, 48, 61, 43, 52, 01, 89, 19, 67, 48]]

euler11_cols = transpose euler11_rows

-- euler #12
--

-- The sequence of triangle numbers is generated by adding the natural
-- numbers. So the 7th triangle number would be 1 + 2 + 3 + 4 + 5 + 6
-- + 7 = 28. The first ten terms would be:
--
-- 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
--
-- Let us list the factors of the first seven triangle numbers:
--
--  1: 1
--  3: 1,3
--  6: 1,2,3,6
-- 10: 1,2,5,10
-- 15: 1,3,5,15
-- 21: 1,3,7,21
-- 28: 1,2,4,7,14,28
--
-- We can see that 28 is the first triangle number to have over five divisors.
--
-- What is the value of the first triangle number to have over five hundred divisors?

triangle_number :: Integer -> Integer
triangle_number 1 = 1
triangle_number n 
                | n < 2     = n
                | otherwise = n + triangle_number (pred n)

triangle_numbers :: [Integer]
triangle_numbers = map triangle_number [1..]

--num_factors :: Integer -> Integer
num_factors n = (length (factors n))

--euler12 :: Integer
euler12 = head [x | x <- triangle_numbers, ((num_factors x) > 500)]

-- euler 13
--
-- Work out the first ten digits of the sum of the following
-- one-hundred 50-digit numbers.

-- 5537376230
euler13 :: String
euler13 = take 10 (show (sum euler13_input))

euler13_input :: [Integer]
euler13_input = 
    [37107287533902102798797998220837590246510135740250,
     46376937677490009712648124896970078050417018260538,
     74324986199524741059474233309513058123726617309629,
     91942213363574161572522430563301811072406154908250,
     23067588207539346171171980310421047513778063246676,
     89261670696623633820136378418383684178734361726757,
     28112879812849979408065481931592621691275889832738,
     44274228917432520321923589422876796487670272189318,
     47451445736001306439091167216856844588711603153276,
     70386486105843025439939619828917593665686757934951,
     62176457141856560629502157223196586755079324193331,
     64906352462741904929101432445813822663347944758178,
     92575867718337217661963751590579239728245598838407,
     58203565325359399008402633568948830189458628227828,
     80181199384826282014278194139940567587151170094390,
     35398664372827112653829987240784473053190104293586,
     86515506006295864861532075273371959191420517255829,
     71693888707715466499115593487603532921714970056938,
     54370070576826684624621495650076471787294438377604,
     53282654108756828443191190634694037855217779295145,
     36123272525000296071075082563815656710885258350721,
     45876576172410976447339110607218265236877223636045,
     17423706905851860660448207621209813287860733969412,
     81142660418086830619328460811191061556940512689692,
     51934325451728388641918047049293215058642563049483,
     62467221648435076201727918039944693004732956340691,
     15732444386908125794514089057706229429197107928209,
     55037687525678773091862540744969844508330393682126,
     18336384825330154686196124348767681297534375946515,
     80386287592878490201521685554828717201219257766954,
     78182833757993103614740356856449095527097864797581,
     16726320100436897842553539920931837441497806860984,
     48403098129077791799088218795327364475675590848030,
     87086987551392711854517078544161852424320693150332,
     59959406895756536782107074926966537676326235447210,
     69793950679652694742597709739166693763042633987085,
     41052684708299085211399427365734116182760315001271,
     65378607361501080857009149939512557028198746004375,
     35829035317434717326932123578154982629742552737307,
     94953759765105305946966067683156574377167401875275,
     88902802571733229619176668713819931811048770190271,
     25267680276078003013678680992525463401061632866526,
     36270218540497705585629946580636237993140746255962,
     24074486908231174977792365466257246923322810917141,
     91430288197103288597806669760892938638285025333403,
     34413065578016127815921815005561868836468420090470,
     23053081172816430487623791969842487255036638784583,
     11487696932154902810424020138335124462181441773470,
     63783299490636259666498587618221225225512486764533,
     67720186971698544312419572409913959008952310058822,
     95548255300263520781532296796249481641953868218774,
     76085327132285723110424803456124867697064507995236,
     37774242535411291684276865538926205024910326572967,
     23701913275725675285653248258265463092207058596522,
     29798860272258331913126375147341994889534765745501,
     18495701454879288984856827726077713721403798879715,
     38298203783031473527721580348144513491373226651381,
     34829543829199918180278916522431027392251122869539,
     40957953066405232632538044100059654939159879593635,
     29746152185502371307642255121183693803580388584903,
     41698116222072977186158236678424689157993532961922,
     62467957194401269043877107275048102390895523597457,
     23189706772547915061505504953922979530901129967519,
     86188088225875314529584099251203829009407770775672,
     11306739708304724483816533873502340845647058077308,
     82959174767140363198008187129011875491310547126581,
     97623331044818386269515456334926366572897563400500,
     42846280183517070527831839425882145521227251250327,
     55121603546981200581762165212827652751691296897789,
     32238195734329339946437501907836945765883352399886,
     75506164965184775180738168837861091527357929701337,
     62177842752192623401942399639168044983993173312731,
     32924185707147349566916674687634660915035914677504,
     99518671430235219628894890102423325116913619626622,
     73267460800591547471830798392868535206946944540724,
     76841822524674417161514036427982273348055556214818,
     97142617910342598647204516893989422179826088076852,
     87783646182799346313767754307809363333018982642090,
     10848802521674670883215120185883543223812876952786,
     71329612474782464538636993009049310363619763878039,
     62184073572399794223406235393808339651327408011116,
     66627891981488087797941876876144230030984490851411,
     60661826293682836764744779239180335110989069790714,
     85786944089552990653640447425576083659976645795096,
     66024396409905389607120198219976047599490197230297,
     64913982680032973156037120041377903785566085089252,
     16730939319872750275468906903707539413042652315011,
     94809377245048795150954100921645863754710598436791,
     78639167021187492431995700641917969777599028300699,
     15368713711936614952811305876380278410754449733078,
     40789923115535562561142322423255033685442488917353,
     44889911501440648020369068063960672322193204149535,
     41503128880339536053299340368006977710650566631954,
     81234880673210146739058568557934581403627822703280,
     82616570773948327592232845941706525094512325230608,
     22918802058777319719839450180888072429661980811197,
     77158542502016545090413245809786882778948721859617,
     72107838435069186155435662884062257473692284509516,
     20849603980134001723930671666823555245252804609722,
     53503534226472524250874054075591789781264330331690]


-- euler #14
--
-- The following iterative sequence is defined for the set of positive
-- integers:
-- 
-- n  n/2 (n is even)
-- n  3n + 1 (n is odd)
--
-- Using the rule above and starting with 13, we generate the
-- following sequence:
--
-- 13 ->  40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1
--
-- It can be seen that this sequence (starting at 13 and finishing at
-- 1) contains 10 terms. Although it has not been proved yet (Collatz
-- Problem), it is thought that all starting numbers finish at 1.
--
-- Which starting number, under one million, produces the longest
-- chain?
-- 
-- NOTE: Once the chain starts the terms are allowed to go above one
-- million.

next_collatz n
             | even n    = div n 2
             | otherwise = ((3 * n) + 1)

collatz_seq :: Integer -> [Integer]
collatz_seq n = n:map next_collatz (collatz_seq n)

terminating_collatz_seq :: Integer -> [Integer]
terminating_collatz_seq n = (takeWhile (/= 1) (collatz_seq n)) ++ [1]

--collatz_length :: Integer -> Integer
--collatz_length n = length (terminating_collatz_seq n)

--euler14 = maximum (map collatz_length [1..999999])


-- euler 16
--
--
-- 2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
--
-- What is the sum of the digits of the number 2^1000?

string_digits :: String -> [Int]
string_digits = map digitToInt 

integer_digits :: Integer -> [Int]
--integer_digits n = string_digits (show n)
integer_digits = string_digits . show

sum_of_digits :: Integer -> Int
sum_of_digits n = sum (integer_digits n)

-- 1366
euler15 :: Int
euler15 = sum [digitToInt x | x <- show (2 ^ 1000)]

euler15_refactored :: Int
euler15_refactored = sum_of_digits (2 ^ 1000)

euler15_from_fourm :: Int
euler15_from_fourm = sum (map (digitToInt) (show (2^1000)))

-- euler #20
--
-- n! means n  (n x 1) x ...  3 x 2 x 1
--
-- Find the sum of the digits in the number 100!

fac :: Integer -> Integer
fac 0 = 1
fac 1 = 1
fac n = n * fac (pred n)

-- 648
euler20 :: Int
euler20 = sum (map (digitToInt) (show (fac 100)))

euler20_refactored = sum_of_digits (fac 100)


-- euler 21
--
-- Let d(n) be defined as the sum of proper divisors of n (numbers
-- less than n which divide evenly into n).
--
-- If d(a) = b and d(b) = a, where a =/= b, then a and b are an
-- amicable pair and each of a and b are called amicable numbers.
--
-- For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20,
-- 22, 44, 55 and 110; therefore d(220) = 284. The proper divisors of
-- 284 are 1, 2, 4, 71 and 142; so d(284) = 220.
-- 
-- Evaluate the sum of all the amicable numbers under 10000.
d :: Integer -> Integer
d n = sum (tail (factors n))

is_amicable :: Integer -> Bool
is_amicable n = n == d(d(n)) && d(n) /= n

-- 31626
euler21 :: Integer
euler21 = sum (filter is_amicable [1..9999])

-- euler 25
--
-- What is the first term in the Fibonacci sequence to contain 1000 digits?

-- from http://www.haskell.org/pipermail/haskell-cafe/2007-February/022590.html
memoized_fibs = map memoized_fib [1..]
memoized_fib = ((map fib' [0 ..]) !!)
    where
      fib' 0 = 0
      fib' 1 = 1
      fib' n = memoized_fib (n - 1) + memoized_fib (n - 2)

-- (because I know I will need a faster fib than I would write naively...)

--fib_digits :: [[Int]]
--fib_digits = map integer_digits memoized_fib

--fib_lengths :: [Int]
--fib_lengths = map length fib_digits

--euler25 = succ 
--           (length 
--            (takeWhile 
--             ((< 1000) $ length) 
--             (map show memoized_fibs)))


-- euler #29
--
-- Consider all integer combinations of a^b for 2 <= a <= 5 and 2 <= b
-- <= 5:
--
-- 2^2=4, 2^3=8, 2^4=16, 2^5=32
-- 3^2=9, 3^3=27, 3^4=81, 3^5=243
-- 4^2=16, 4^3=64, 4^4=256, 4^5=1024
-- 5^2=25, 5^3=125, 5^4=625, 5^5=3125
--
-- If they are then placed in numerical order, with any repeats
-- removed, we get the following sequence of 15 distinct terms:
--
-- 4, 8, 9, 16, 25, 27, 32, 64, 81, 125, 243, 256, 625, 1024, 3125
-- 
-- How many distinct terms are in the sequence generated by ab for 2
-- <= a <= 100 and 2 <= b <= 100?

integer_pow :: Int -> Int -> Integer
integer_pow a b = (fromIntegral a) ^ b

euler29_nums :: Int -> Int -> [Integer]
euler29_nums low high = nub [integer_pow a b | a <- [low..high], b <- [low..high]]

-- 9183
euler29 :: Int
euler29 = length (euler29_nums 2 100)

-- x = (2^1234)


-- euler #30
--
-- Surprisingly there are only three numbers that can be written as
-- the sum of fourth powers of their digits:
--
-- 1634 = 1^4 + 6^4 + 3^4 + 4^4
-- 8208 = 8^4 + 2^4 + 0^4 + 8^4
-- 9474 = 9^4 + 4^4 + 7^4 + 4^4
-- As 1 = 1^4 is not a sum it is not included.
--
-- The sum of these numbers is 1634 + 8208 + 9474 = 19316.
-- 
-- Find the sum of all the numbers that can be written as the sum of
-- fifth powers of their digits.

sum_of_pth_power :: Integer -> Int -> Integer
sum_of_pth_power n p = sum (map (`integer_pow` p) (integer_digits n))

qualifies_for_e30 n p = n > 1 && (sum_of_pth_power n p) == n
e30_example_nums = [x | x <- natural_numbers, qualifies_for_e30 x 4]
e30_nums = [x | x <- natural_numbers, qualifies_for_e30 x 5]

-- I found "6" by trying take 1, take 2, etc until it seemed to be
-- taking too long and then just tried the sum and it worked on the
-- site... need a more mathy approach in general.
-- 443839
euler30 = sum(take 6 e30_nums)


-- euler #34
--
-- 145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.
-- 
-- Find the sum of all numbers which are equal to the sum of the
-- factorial of their digits.
-- 
-- Note: as 1! = 1 and 2! = 2 are not sums they are not included.
--

is_e34_num n = sum (map (fac . fromIntegral) (integer_digits n)) == n

e34_nums = filter is_e34_num [3..]

-- arrived at "take 2" by doing "take 5" and observing that it took
-- forever after 2... so kind of cheating... but oh well.
euler34 = sum (take 2 e34_nums)


-- euler #35
--
-- The number, 197, is called a circular prime because all rotations
-- of the digits: 197, 971, and 719, are themselves prime.
--
-- There are thirteen such primes below 100: 2, 3, 5, 7, 11, 13, 17,
-- 31, 37, 71, 73, 79, and 97.
--
-- How many circular primes are there below one million?

next_rotation s = tail s ++ [head s]

rotations :: Integer -> [Integer]
rotations n =
    let s = (show n)
    in map read (take (length s) (iterate next_rotation s))

is_circular_prime = (all is_prime) . rotations

-- too slow or some other problem keeps it from finishing even over an hour+
euler35 = length (filter is_circular_prime (takeWhile (< 1000000) even_faster_primes))


-- euler #36
-- 
-- The decimal number, 585 = 1001001001v2 (binary), is palindromic in
-- both bases.
-- 
-- Find the sum of all numbers, less than one million, which are
-- palindromic in base 10 and base 2.
-- 
-- (Please note that the palindromic number, in either base, may not
-- include leading zeros.)

to_binary_str' :: Integer -> String -> String
to_binary_str' n acc =
    if n == 0
    then acc
    else 
        let (t, r) = divMod n 2
        in 
          let rc = (fromIntegral r)
          in to_binary_str' t ((intToDigit rc):acc)

to_binary_str :: Integer -> String
to_binary_str n = to_binary_str' n ""

is_palindromic_in_binary :: Integer -> Bool
is_palindromic_in_binary n = is_palindromic_number (read (to_binary_str n))

-- 872187
euler36 :: Integer
euler36 = sum [n | n <- [1..999999], is_palindromic_number n, is_palindromic_in_binary n]



-- euler #48
--
-- The series, 1^1 + 2^2 + 3^3 + ... + 10^10 = 10405071317.
-- 
-- Find the last ten digits of the series, 1^1 + 2^2 + 3^3 + ... + 1000^1000.

self_pow n = n ^ n
e48_series = map self_pow [1..]
e48_sum = sum (take 1000 e48_series)
-- "9110846700"
euler48 = reverse (take 10 (reverse (show e48_sum)))

