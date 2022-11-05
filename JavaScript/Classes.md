# Classes

[Classes Intro](https://www.digitalocean.com/community/tutorials/understanding-classes-in-javascript)
[Complete Guide](https://dmitripavlutin.com/javascript-classes-complete-guide/)

- <https://javascript.info/class>
- <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes>
- always in `strict mode`
- First letter is capitalized to identify constructor.
- The JavaScript language has nine built-in constructors: Object(), Array(), String(), Number(), Boolean(), Date(), Function(), Error() and RegExp().

**Object Literals**

- When creating values, we are free to use either `object literals` or `class constructors`. However, object literals are not only easier to read but also faster to run, because they can be optimized at parse time. Thus, for simple objects it’s best to stick with literals.
- What’s more interesting is that it’s still possible to call methods on literals. When a method is called on a literal, JavaScript automatically converts the literal into a temporary object so that the method can perform the operation. Once the temporary object is no longer needed, JavaScript discards it.

# New

- The Keyword **new** determines whether or not a function is a constructor.
- The 'new' keyword creates a new object, which is bound to `this` of the `object`.
- Missing the new keyword creates the variables on the `Global/Window object` which can be accessed from anywhere. It’s important to remember to use the `new` keyword before all constructors. If you accidentally forget `new`, you will be modifying the global object instead of the newly created object.
  - When we call the a function constructor without new, we are in fact calling a function without a return statement. As a result, **this** inside the constructor points to `Window (global)` (instead of myBook), and two global variables are created. However, when we call the function with `new`, the context is switched from global (Window) to the instance. So, **this** correctly points to myBook.
- Note that in **strict mode** this code would throw an error because strict mode is designed to protect the programmer from accidentally calling a constructor without the new keyword.

# Prototypes

- If you change the property of a linked prototype, all linked objects will get the change.
- All prototypes will be assigned to the `new` instantiated object.
- `Name.prototype.functionName = function(){}` will be added to all `new` objects, even if they were created before function was added.

**Object based Constructors**

```ts
// Get or set prototype
Object.getPrototypeOf(obj);
Object.setPrototypeOf(obj);
// immutable Constructor object
const Greeter = Object.freeze({
  init: function (phrase) {
    return Object.assign({}, this, { phrase });
  },
  greet(name) {
    // new way to write method!!!!
    return this.phrase + name;
  },
});
const sayHello = Greeter.init('Hello ');
const sayGoodMorning = Greeter.init('Good Morning ');
console.log(sayHello.greet('John')); // Hello John
console.log(sayGoodMorning.greet('John')); // Good Morning John
```

# Constructor

- if you don't create a constructor, an empty one is created for you.
- [_https://css-tricks.com/understanding-javascript-constructors/_](https://css-tricks.com/understanding-javascript-constructors/)
- Create **Safe Constructor** with `new` keyword checking:
  - The if statement checks if object is tied to the 'this' keyword, if
    not, it ties it to the object.

```ts
class Home {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
}

//  ES5  Function Constructor.
const Person = function (firstName, lastName, age) {
  this.firstName = firstName;
  this.lastName = lastName;
  this.age = age;

  //'this' not needed because arguments exist in constructor.
  this.name = () => firstName + ' ' + lastName;

  // will add a new property 'isSleeping = true' on object when called.
  this.sleep = () => (this.isSleeping = true);
};

// add new method 'getBio' to Person Constructor.
Person.prototype.getBio = function () {
  return `${this.firstName}  is  ${this.age}.`;
};

// add new property to Person Constructor and assigning it a value.
Person.prototype.location = 'Thailand';
const me = new Person('Bob', 'Jones', 24); //  {  firstName:  "Bob",  lastName:  "Jones",  age:  24  }
console.log(me.location); //  Thailand
const anotherMe = new Person('Clancey', 'Turner', 33); //  {  firstName:  "Clancey",  lastName:  "Turner",  age:  33  }
console.log(anotherMe.location); //  Thailand

// Overwrite Main prototype constructor:
Person.prototype.getBio = function () {
  return 'Test  1';
};

// me.getBio() returns'Test 1'. This changes all getBio objects made from this constructor. This is because everything is linked to the same object prototype.
```

# Properties

- `__propertyName` naming convention for private properties that shouldn't be directly manipulated.

**Function Constructor vs Class Constructor**

- <https://www.digitalocean.com/community/tutorials/understanding-classes-in-javascript>

<img src="images/es5vses6.png" alt="ES5 Constructor vs ES6">
