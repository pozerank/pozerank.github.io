---
title:  "Do Not Store User Passwords in This Way"
date:   2023-07-10 11:00:00
categories: [architecture, security, tools, english]
tags: [user credentials, store, passwords, encryption, decryption hashing, digest, SHA-256, SHA512, MD5, is safe, rainbow tables, salt, salting, peppering, schema, vault, english, mehmet cem yucel]
image: https://miro.medium.com/v2/resize:fit:150/1*51yiQNFp5KyP3ncI5-zVJA.jpeg
---

One of the most critical topics in software development is secure storage of passwords. A data leak can lead to issues concerning both customers and legal regulations. Therefore, today we will focus on best practices regarding these topics.

-   Encryption / Hashing
-   Rainbow Tables / Salting & Peppering
-   Auth Schema Seperation
-   Work Factors
-   Vaults

![](https://miro.medium.com/v2/resize:fit:1400/0*noOeyOHQ_1V_SjmA.jpeg)


## Use Hash Functions Instead of Encryption

Encryption is a two way function. Thats mean, you can retrieve plain text.  [Symmetric](https://www-mehmetcemyucel-com.translate.goog/2017/simetrik-sifreleme-ve-blockchain/?_x_tr_sl=tr&_x_tr_tl=en&_x_tr_hl=tr&_x_tr_pto=wapp)  and  [asymmetric](https://www-mehmetcemyucel-com.translate.goog/2017/asimetrik-sifreleme-ve-blockchain/?_x_tr_sl=tr&_x_tr_tl=en&_x_tr_hl=tr&_x_tr_pto=wapp)  encryption methods can be explored through links. If a password becomes readable again, it poses a security risk.

[Hash functions](https://www-mehmetcemyucel-com.translate.goog/2017/hash-fonksiyonlari-ve-blockchain/?_x_tr_sl=tr&_x_tr_tl=en&_x_tr_hl=tr&_x_tr_pto=wapp)  are one way functions instead of encryption methods. You can not retrieve plain text from an output of(digest) hash functions. When a user prefer to login a system, enters password and hash function recreates the digest. The recorded hash in the database is compared with the hash of input value. If they are same verification is successful.

A notice, if you are a user of a website that can send you your plain password with “Forgetten Password” flow, don’t use this website or choose your password carefully :)

SHA-1 and MD5 hash algorithms are not secure because of collision problems. You can prefer more secure SHA-256, SHA-512 algorithm.

{% include feed-ici-yazi-2.html %}

## Hash Ok, Are We Safe Now?

Not yet. We have new problems.

Each input of hash functions has a unique output. That means, if you generate a table with plaintext/digest columns and fill them with commonly used passwords(from a dictionary) by generating hashes using commonly used hash algorithms, it becomes possible to retrieve the plaintext version of a hash from the table.

For example, i generated a MD5 hash for “password” credential.

![](https://miro.medium.com/v2/resize:fit:1400/0*TRTceXIsa6YYWmab.png)

There are many rainbow tables on the internet. I will search my hash value at the one of them.

![](https://miro.medium.com/v2/resize:fit:1400/0*IA3ugGyi02-O6evR.png)

This is proof that hash functions alone are not sufficient. Because we cannot guarantee that end users will always create secure passwords.

## Salting & Peppering

The concept of salting involves adding a randomly generated character set as a prefix to sensitive data. Let’s examine the example.

![](https://miro.medium.com/v2/resize:fit:1400/0*D6CV4EHSUJ4Pz2HW.png)

I added a random value as a prefix to password and generated hash with this value. Let’s search new hash in rainbow tables.

![](https://miro.medium.com/v2/resize:fit:1400/0*br_sRfg2omJf2QX4.png)

This time hash value can not be founded. Because this combination is not a “most used password” combination now. By doing this, sensitive data is prefixed with a randomly generated character set, which is known as  **salting**. You can store salt value with a new column in database. Additionally if you prefer same thing as postfix and store value in file system/object storage, that called as  **peppering**.

{% include feed-ici-yazi-1.html %}

## Separation of Auth Schema

Security of a system must be designed layer by layer, as an onion. If an attacker gets access to a layer, other layers must be still safe.

Imagine that, we have a system that secured by JWT tokens. All of our business services can be accessible with a valid access token. But what about our public endpoints like login, forgotten password etc.? They are most vulnerable services in our system. For example if we have an sql-injection weakness at this services an attacker can access our database and business tables without any username&password. This vulnerability can be very costly for the organization.

For this reason we prefer to separate auth tables to different db schema. This isolation has one more advantage. With this isolation you can decrease risk of internal users. You can keep this scheme under control by allowing access to a limited number of people.

## Work Factors

By the simplest definition, running hash function n times with output as input of previous execution. There are different algorithms that uses this logic internally(PBKDF2 etc).

The main purpose of this method is to increase CPU cost and making it more difficult to create rainbow tables. The point that needs to be noted is, this cost should not to be a problem for our functional operations. n parameter(factor) should be optimized.

{% include feed-ici-yazi-1.html %}

## Vaults

Vaults are big topic that can be explained in a different story but i will provide a brief summary. Vaults are ID and access management tools. Not only passwords, you can store certificates, sensitive files, API keys, DB passwords etc. You can generate access scenarios to this assets, e.g “there should be 3 different user tokens to unseal vault”.

Security is not only software issue, at the same time it is an architecture issue. For example, transferring a sensitive data on insecure network as big security risks. Or storing a password in application memory is not secure, an attacker can access this information with a memory dump. For this reasons all sensitive datas should be used/transferred secure in all infrastructure. Vaults handle this topics in their development. Some sample tools;

-   [https://www.vaultproject.io/](https://www.vaultproject.io/)
-   [https://www.cyberark.com/](https://www.cyberark.com/)
-   [https://www.beyondtrust.com/](https://www.beyondtrust.com/)

## Conclusion

Don’t forget to keep up with the  [OWASP](https://owasp.org/)  website as new vulnerabilities are emerging every day.