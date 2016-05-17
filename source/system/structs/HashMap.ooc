/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

_HashEntry: class <K, V> {
	_key: __onheap__ K
	_value: __onheap__ V
	_next: This<K, V> = null
	init: func (=_key, =_value)
	free: override func {
		memfree(this _key)
		memfree(this _value)
		if (this _next != null) {
			this _next free()
			this _next = null
		}
		super()
	}
}

// Austin Appleby's Murmur Hash implementation: http://code.google.com/p/smhasher/
_murmurHash: func <K> (key: K) -> Int {
	(len, m, r, l, h, t) := (K size, 0x5bd1e995 as SizeT, 24 as SizeT, len, (1 as SizeT) ^ len as SizeT, 0)
	data := (key&) as Byte*
	while (len >= 4) {
		k := (data as SizeT*)@
		k *= m
		k ^= k >> r
		k *= m
		h *= m
		h ^= k
		data += 4
		if (len < 4) break
		len -= 4
	}
	if (len == 3) h ^= data[2] << 16
	if (len == 2) h ^= data[1] << 8
	if (len == 1) h ^= data[0]
	t *= m; t ^= t >> r; t *= m; h *= m; h ^= t
	l *= m; l ^= l >> r; l *= m; h *= m; h ^= l
	h ^= h >> 13; h *= m; h ^= h >> 15
	h as Int
}

// khash's ac_X31_hash_string: http://attractivechaos.awardspace.com/khash.h.html
_acX31Hash: func <K> (key: K) -> Int {
	s: Char* = (K == String) ? (key as String) toCString() as Char* : key as Char*
	h = s@ : Int
	if (h) {
		s += 1
		while (s@) {
			h = (h << 5) - h + s@
			s += 1
		}
	}
	h
}

HashMap: class <K, V> {
	_count: Int
	_capacity: Int
	_buckets: _HashEntry<K, V>[]

	count ::= this _count
	isEmpty ::= this _count == 0
	capacity ::= this _capacity

	init: func ~default { this init(31) }
	init: func (=_capacity) {
		this _count = 0
		this _buckets = _HashEntry[this _capacity] new()
	}
	free: override func {
		this clear()
		this _buckets free()
		super()
	}
	put: func (key: K, value: V) -> V {
		if ((this _count as Float / this _capacity as Float) > 0.75f)
			this resize(this _count * 3)
		existingValue: V = this remove(key)
		this _count += 1
		hashkey := This hash(key) % this capacity
		entry := _HashEntry<K, V> new(key, value)
		entry _next = this _buckets[hashkey]
		this _buckets[hashkey] = entry
		existingValue
	}
	get: func ~nulldefault (key: K) -> V {
		this get(key, null)
	}
	get: func (key: K, defaultValue: V) -> V {
		result: V = defaultValue
		if (this contains(key)) {
			hashkey := This hash(key) % this capacity
			entry := this _buckets[hashkey]
			while (!this _keyEquals(key, entry _key))
				entry = entry _next
			result = entry _value
		}
		result
	}
	clear: func {
		for (index in 0 .. this capacity)
			if (this _buckets[index] != null) {
				this _buckets[index] free()
				this _buckets[index] = null
			}
		this _count = 0
	}
	remove: func ~nulldefault (key: K) -> V {
		this remove(key, null)
	}
	remove: func (key: K, defaultValue: V) -> V {
		result: V = defaultValue
		hashkey := This hash(key) % this capacity
		entry := this _buckets[hashkey]
		if (entry != null) {
			if (this _keyEquals(key, entry _key)) {
				next := entry _next
				entry _next = null
				result = entry _value
				entry free()
				this _buckets[hashkey] = next
				this _count -= 1
			} else {
				prev := entry
				entry = entry _next
				while (entry != null && !this _keyEquals(key, entry _key)) {
					prev = entry
					entry = entry _next
				}
				if (entry != null) {
					prev _next = entry _next
					entry _next = null
					result = entry _value
					entry free()
					this _count -= 1
				}
			}
		}
		result
	}
	contains: func (key: K) -> Bool {
		hashkey := This hash(key) % this capacity
		result := false
		entry := this _buckets[hashkey]
		while (entry != null) {
			if (this _keyEquals(key, entry _key)) {
				result = true
				break
			}
			entry = entry _next
		}
		result
	}
	each: func (action: Func (V*)) {
		for (index in 0 .. this capacity) {
			entry := this _buckets[index]
			while (entry != null) {
				action(entry _value&)
				entry = entry _next
			}
		}
	}
	each: func ~withKeys (action: Func (K*, V*)) {
		for (index in 0 .. this capacity) {
			entry := this _buckets[index]
			while (entry != null) {
				action(entry _key&, entry _value&)
				entry = entry _next
			}
		}
	}
	resize: func (newCapacity: Int) {
		oldCapacity := this capacity
		oldBuckets := this _buckets
		this _count = 0
		this _capacity = newCapacity
		this _buckets = _HashEntry[this capacity] new()
		for (i in 0 .. oldCapacity) {
			entry := oldBuckets[i]
			while (entry != null) {
				this put(entry _key, entry _value)
				entry = entry _next
			}
			if (oldBuckets[i] != null)
				oldBuckets[i] free()
		}
		oldBuckets free()
	}
	_keyEquals: func (first, second: K) -> Bool {
		match (K) {
			case Int => first as Int == second as Int
			case String => first as String equals(second as String)
			case Text => first as Text == second as Text
			case => memcmp(first, second, K size) == 0
		}
	}
	hash: static func <K> (key: K) -> Int {
		result := match (K) {
			case Int => key as Int
			case String => _acX31Hash(key as String)
			case Text => _acX31Hash(key as Text _buffer _backend)
			case => _murmurHash(key)
		}
		result < 0 ? -result : result
	}
}

operator [] <K, V> (map: HashMap<K, V>, key: K) -> V { map get(key) }
operator []= <K, V> (map: HashMap<K, V>, key: K, value: V) { map put(key, value) }
