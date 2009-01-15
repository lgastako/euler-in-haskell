
-- euler #1 
--
-- If we list all the natural numbers below 10 that are multiples of 3
-- or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
-- 
-- Find the sum of all the multiples of 3 or 5 below 1000.

-- 233168
euler1 :: Integer
euler1 = sum [x | x <- take 1000 [0..], x `mod` 3 == 0 || x `mod` 5 == 0]


-- euler #2
--
-- Each new term in the Fibonacci sequence is generated by adding the
-- previous two terms. By starting with 1 and 2, the first 10 terms
-- will be: 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...  Find the sum of
-- all the even-valued terms in the sequence which do not exceed four
-- million.

fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

sum_evens_under :: Integer -> [Integer] -> Integer
sum_evens_under n seq = sum [x | x <- takeWhile (< n) seq, x `mod` 2 == 0]

-- 4613732
euler2 :: Integer
euler2 = sum_evens_under 4000000 fibs

-- From forum on projecteuler.net
alt_euler2 = sum . takeWhile (< 4000000) . filter even $ fibs

factor :: Integer -> Integer -> Bool
factor n m = n `mod` m == 0

factors :: Integer -> [Integer]
factors n = n:(takeWhile (< n) . filter (factor n) $ [1..])

prime :: Integer -> Bool
prime n = length (factors n) <= 2

prime_factors :: Integer -> [Integer]
prime_factors n = filter prime (factors n)

-- euler #3
--
-- The prime factors of 13195 are 5, 7, 13 and 29.
-- What is the largest prime factor of the number 600851475143 ?
euler3 :: Integer
euler3 = maximum (prime_factors 600851475143)
-- Probably correct but to slow


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

-- 906609
euler4 :: Integer
euler4 = maximum 
         (filter 
          is_palindromic_number
          [x * y | x <- three_digit_numbers, y <- three_digit_numbers ])


-- euler #5
--
-- 2520 is the smallest number that can be divided by each of the
-- numbers from 1 to 10 without any remainder.

What is the smallest number that is evenly divisible by all of the numbers from 1 to 20?
euler5 :: Integer
euler5 = 0

--main = do
  -- putStr (show euler3)


