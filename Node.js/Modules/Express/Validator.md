# Express Validator

- <https://github.com/express-validator/express-validator>
- <https://www.npmjs.com/package/express-validator> TS
- `npm i express-validator`

docs

- <https://express-validator.github.io/docs/>

**validation.ts**

```ts
import { body } from 'express-validator';

export const emailPasswordValidate = [
  body('email').isEmail().withMessage('Email must be valid.'),
  body('password')
    .trim()
    .isLength({ min: 2, max: 20 })
    .withMessage('Password length must be at least 2 and less than 20.'),
];
```

**functions.ts**

```ts
import {
  RequestValidationError,
  DatabaseError,
  httpStatusCodes,
} from '../errors';

export async function signIn(req: Request, res: Response, next: NextFunction) {
  const errors = validationResult(req);
  if (!errors.isEmpty())
    return next(
      new RequestValidationError(httpStatusCodes.BAD_REQUEST, errors.array())
    );
```

**index.ts**

```ts
import express from 'express';
import { signIn } from './users-functions';
import { emailPasswordValidate } from './validators';

const router = express.Router();

router.route('/signin').post(emailPasswordValidate, signIn);
export default router;
```

# Validataor.js

- <https://github.com/validatorjs/validator.js>
