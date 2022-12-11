#!/bin/bash

# create a complete express, mongoose file structure.

echo $1
mkdir "$1"
cd "$1" # -------------------------------------------------

# install npm packages
npm init -y
npm i chalk cors dotenv express express-async-errors express-validator mongoose
npm i -D @types/cors @types/express @types/node ts-node 

# package.json 
m=$(cat << EOF
"main": "src/server.ts",
EOF
)
sed -ie "s@\"main.*@${m}@" package.json

s=$(cat << EOF
  "scripts": {
    "dev": "NODE_ENV=development tsc-watch --onSuccess \\\\"node ./build/server.js\\\\"",
    "prod": "NODE_ENV=production tsc-watch --onSuccess \\\\"node ./build/server.js\\\\"",
    "build": "rm -rf build/ && tsc",
    "start": "tsc-watch --onSuccess \\\\"node ./build/index.js\\\\""
  },
  "keywords": [],
EOF
)
perl -i -0pe "s@.*\"scripts.*(\n|.)*\"keywords\": \[\],@${s}@" package.json
# perl leaves temp file?
rm package.jsone

# create .prettierrc
cat << EOF > ".prettierrc"
{
    "singleQuote": true,
    "printWidth": 200,
    "proseWrap": "always",
    "tabWidth": 2,
    "useTabs": false,
    "trailingComma": "none",
    "bracketSpacing": true,
    "jsxBracketSameLine": false,
    "semi": true
}
EOF

# vscode settings
mkdir .vscode
cat << EOF > ".vscode/settings.json"
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.bracketPairColorization.enabled": true,
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.wordWrap": "on"
}
EOF

# tsconfig.json
cat << EOF > "tsconfig.json"
{
  "compilerOptions": {
    "target": "es2016",
    "module": "commonjs",
    "outDir": "./build",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"]
}
EOF

# Docker
cat << EOF > "Dockerfile"
FROM node:19.2-alpine
WORKDIR /app
COPY package.json .
RUN npm i
COPY . .
RUN npm run build
EXPOSE 4000
CMD [ "node", "build/index.js" ]
EOF
# .dockerignore
cat << EOF > ".dockerignore"
**/.vscode
**/node_modules
package-lock.json
build
.prettierrc
EOF

# .env
cat << EOF > ".env"
SALT=5e5839c2424536512f4b415a70d35f08
MONGO_USER=root
MONGO_PASSWORD=password
EOF

# src -------------------------------------------------
mkdir -p src/{config,controllers,errors,library,models,routes,validators}
cd src

# server.ts
cat << 'EOF' > "server.ts"
import express, { Application, NextFunction, Request, Response, Router } from 'express';
import 'express-async-errors';
import 'dotenv/config';
import chalk from 'chalk';
// import ${1}Router from './routes/${1}';
import { errorHandler, RouteError, DatabaseError, httpStatusCodes } from './errors';
import mongoose from 'mongoose';
import Log from './library/Logging';
import { config } from './config';

const app: Application = express();
const port = 4000;

/** Connect to Mongo */
mongoose.set('strictQuery', false);
mongoose
  .connect(
    // `mongodb://root:password@mongo-svc:27017`
    `mongodb://${config.mongo.user}:${config.mongo.password}@localhost:27017/AuthDB`,
    { authSource: 'admin', w: 'majority', retryWrites: true }
  )
  .then(() => {
    Log.info('Connected to MongoDB!!!');
    StartServer();
  })
  .catch((e) => {
    throw new DatabaseError(httpStatusCodes.BAD_REQUEST, e);
  });

/** Express Rest API */
async function StartServer() {
  // logging
  app.use((req, res, next) => {
    // log incoming request.
    Log.info(`Incoming -> Method: [${chalk.yellow(req.method)}] - Url: [${chalk.yellow(req.url)}] - IP: [${chalk.yellow(req.socket.remoteAddress)}]`);

    res.on('finish', () => {
      // log response status
      const code = res.statusCode;
      const color = code >= 300 ? chalk.red : chalk.green;
      Log.info(`Outgoing -> Method: [${chalk.yellow(req.method)}] - Url: [${chalk.yellow(req.url)}] - IP: [${chalk.yellow(req.socket.remoteAddress)}] - StatusCode: [${color(res.statusCode)}]`);
    });
    next();
  });

  app.use(express.urlencoded({ extended: true }));
  app.use(express.json());

  /** Rules of API */
  app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');

    if (req.method == 'OPTIONS') {
      res.header('Access-Control-Allow-Methods', 'PUT, POST, PATCH, DELETE, GET');
      return res.status(200).json({});
    }
    next();
  });

  /** Routes */
  // HOF wrapper
  const use =
    (fn: any) =>
    (req: Request, res: Response, next: NextFunction): Promise<Router> =>
      Promise.resolve(fn(req, res, next)).catch(next);
  // all routes wrap in the 'use' function
  // app.use('/api/v1/${1}', use(${1}Router));

  /** HealthCheck */
  app.get('/ping', (req, res, next) => {
    res.status(200).json({ message: 'pong' });
  });

  app.all('*', async (req: Request, res: Response, next: NextFunction) => {
    throw new RouteError();
  });
  app.use(errorHandler);

  app.listen(port, () => {
    Log.info(`⚡️[server]: Server is running at https://localhost:${port}`);
  });
}
EOF


# create config
cat << EOF > "config/config.ts"
import 'dotenv/config';

const SALT = process.env.SALT || '';
const MONGO_USER = process.env.MONGO_USER || '';
const MONGO_PASSWORD = process.env.MONGO_PASSWORD || '';

export const config = {
  password: {
    salt: SALT
  },
  mongo: {
    user: MONGO_USER,
    password: MONGO_PASSWORD
  }
};
EOF
cat << EOF > "config/index.ts"
export * from './config';
EOF


# controllers
cat << EOF > "controllers/${1}Controller.ts"
import { Request, Response, NextFunction } from 'express';
import 'dotenv/config';
import { validationResult, ValidationError } from 'express-validator';
import { RequestValidationError, DatabaseError, httpStatusCodes } from '../errors';
import { ${1} } from '../models/${1}Schema';
import Log from '../library/Logging';

export async function signIn(req: Request, res: Response, next: NextFunction) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) throw new RequestValidationError(httpStatusCodes.BAD_REQUEST, errors.array());

  const { email, password } = req.body;
  // throw new DatabaseError(httpStatusCodes.BAD_REQUEST);
  // throw new Error('my bad!');
  const me = await ${1}.create({ email, password });
  Log.info(me);

  res.status(200).json({ data: { email, password }, msg: 'Email Password Success!' });
}

export async function signUp(req: Request, res: Response, next: NextFunction) {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ data: 'please provide email and password' });
  res.status(200).json({ data: { email, password }, msg: 'Email Password Success!' });
}

export async function signOut(req: Request, res: Response, next: NextFunction) {
  // const { email, password } = req.body;
  // if (!email || !password)
  //   return res.status(400).json({ data: 'please provide email and password' });
  res.status(200).json({ data: {}, msg: 'Sign out successful!' });
}

export async function currentUser(req: Request, res: Response, next: NextFunction) {
  // const { email, password } = req.body;
  // if (!email || !password)
  //   return res.status(400).json({ data: 'please provide email and password' });
  res.status(200).json({ data: { user: {} }, msg: 'Current User' });
}
EOF


# errors
cat << 'EOF' > "errors/errors.ts"
import { Request, Response, NextFunction } from 'express';
import Log from '../library/Logging';
import { ValidationError } from 'express-validator';

export const httpStatusCodes = {
  OK: 200,
  BAD_REQUEST: 400,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  INTERNAL_SERVER: 500,
  SERVICE_UNAVAILABLE: 503
};

// this will keep enforcing error schema after TS is translated.
abstract class CustomError extends Error {
  abstract statusCode: number;
  constructor(message: string) {
    super(message);
    // https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-2.html#example
    // this allows 'instanceof' to correctly identify between Error and YourErrorName.
    // all extended classes will correctly identify with this code.
    Object.setPrototypeOf(this, new.target.prototype);
  }
  abstract serializeErrors(): { msg: string; field: string }[];
}

export class RequestValidationError extends CustomError {
  constructor(public statusCode: number = httpStatusCodes.BAD_REQUEST, public errors: ValidationError[]) {
    super('Express-Validator Error.');
  }

  serializeErrors() {
    return this.errors.map((e) => ({
      msg: e.msg,
      field: e.param
    }));
  }
}

export class DatabaseError extends CustomError {
  constructor(public statusCode: number = httpStatusCodes.INTERNAL_SERVER, public err?: Error) {
    super('Database Connection Error');
  }
  serializeErrors() {
    return [
      {
        msg: this.message,
        field: 'Database Error',
        err: this.err?.stack || ''
      }
    ];
  }
}
export class RouteError extends CustomError {
  constructor(public statusCode: number = httpStatusCodes.NOT_FOUND) {
    super('Route Not Found.');
  }
  serializeErrors() {
    return [
      {
        msg: this.message,
        field: 'Route Error'
      }
    ];
  }
}

export const errorHandler = (err: RequestValidationError | DatabaseError | Error, req: Request, res: Response, next: NextFunction) => {
  Log.error(err.stack);
  if (err instanceof CustomError) return res.status(err.statusCode).json({ errors: err.serializeErrors() });

  // generic error
  res.status(httpStatusCodes.BAD_REQUEST).json({
    errors: [
      {
        msg: err.message,
        field: 'error'
      }
    ]
  });
};
EOF
cat << EOF > "errors/index.ts"
export * from './errors';
EOF


# model -mongoose schema
cat << EOF > "models/${1}Schema.ts"
import mongoose, { Schema, model, Model, QueryOptions, Types } from 'mongoose';
import crypto from 'crypto';
import { config } from '../config';

export interface ${1}Type {
  _id: Types.ObjectId;
  id: string;
  email: string;
  password: string;
}

export interface ${1}TypeMethods {}

export interface ${1}Model extends Model<${1}Type, {}, ${1}TypeMethods> {
  hashMyPassword: (pw: string, salt: string) => Promise<string>;
}

const ${1}Schema = new Schema<${1}Type, ${1}Model, ${1}TypeMethods>({
  email: {
    type: String,
    required: [true, 'Email is required.'],
    unique: true,
    lowercase: true,
    maxLength: [40, 'Email cannot be over 40 characters.'],
    minLength: [3, 'Valid email cannot be less than 3 characters.']
  },
  password: {
    type: String,
    required: [true, 'Password is required.'],
    select: false
  }
});

export const hashPassword = async (password: string, salt: string) => crypto.pbkdf2Sync(password, salt, 1000, 64, `sha512`).toString(`hex`);

${1}Schema.static('hashPassword', hashPassword);

${1}Schema.pre('save', async function (next) {
  this.password = await hashPassword(this.password, config.password.salt);
  return next();
});

export const Auth = model<${1}Type, ${1}Model>('${1}s', ${1}Schema);
EOF



# library
cat << 'EOF' > "library/Logging.ts"
import chalk from 'chalk';

export default class Log {
  public static log = (args: any) => this.info(args);
  public static info = (args: any) => console.log(chalk.blue(`[${new Date().toLocaleString()}] [INFO]`, typeof args === 'string' ? chalk.blueBright(args) : args));
  public static warn = (args: any) => console.log(chalk.yellow(`[${new Date().toLocaleString()}] [INFO]`, typeof args === 'string' ? chalk.yellowBright(args) : args));
  public static error = (args: any) => console.log(chalk.red(`[${new Date().toLocaleString()}] [INFO]`, typeof args === 'string' ? chalk.redBright(args) : args));
}
EOF

# routes
cat << EOF > "routes/${1}Router.ts"
import express from 'express';
import { signIn, signUp, signOut, currentUser } from '../controllers/AuthController';
import { emailPasswordValidate } from '../validators';

// ${1}
const router = express.Router();
// http://tickets.prod/api/v1/users/signin
router.route('/signin').post(emailPasswordValidate, signIn);
router.route('/signup').post(signUp);
router.route('/signout').post(signOut);
router.route('/currentuser').get(currentUser);

export default router;
EOF

# validator
cat << EOF > "validators/${1}Validator.ts"
import { body } from 'express-validator';

export const emailPasswordValidate = [
  body('email').isEmail().withMessage('Email must be valid.'),
  body('password')
    .trim()
    .isLength({ min: 2, max: 20 })
    .withMessage('Password length must be at least 2 and less than 20.'),
];
EOF
cat << EOF > "validators/index.ts"
export * from './${1}Validator';
EOF



cd ../../