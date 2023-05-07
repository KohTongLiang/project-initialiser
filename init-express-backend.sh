#!/bin/bash

# Get the project name from the command line argument
project_name=$1

if [ -z "$project_name" ]; then
	  echo "Please provide a project name as the first argument."
		  exit 1
fi

# Create project folder and initialize
mkdir "$project_name"
cd "$project_name"
npm init -y

# Install dependencies
npm i express cors dotenv helmet express-rate-limit winston winston-daily-rotate-file lodash body-parser
npm i --save-dev typescript ts-node nodemon @types/node @types/express @types/cors eslint prettier eslint-plugin-import eslint-plugin-prettier eslint-plugin-simple-import-sort @typescript-eslint/eslint-plugin @typescript-eslint/parser

# Create environment variables file
touch .env
cat > .env <<EOL
PORT=3000
EOL

# Create and configure tsconfig.json
cat > tsconfig.json <<EOL
{
  "compilerOptions": {
	    "target": "es6",
	    "module": "commonjs",
	    "outDir": "./dist",
	    "strict": true,
	    "esModuleInterop": true,
	    "skipLibCheck": true,
	    "forceConsistentCasingInFileNames": true,
	    "moduleResolution": "node"
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules"]
}
EOL

# Create and configure nodemon.json
cat > nodemon.json <<EOL
{
  "watch": ["src"],
  "ext": "ts",
  "exec": "ts-node ./src/index.ts",
  "ignore": ["src/**/*.spec.ts"]
}
EOL

# setup linting
cat > .eslintrc.json <<EOL
{
  "extends": [
	    "plugin:@typescript-eslint/recommended",
			"plugin:prettier/recommended",
		  "prettier/@typescript-eslint"
		  ],
		  "plugins": ["import", "simple-import-sort"],
		  "parser": "@typescript-eslint/parser",
		  "parserOptions": {
		   "ecmaVersion": 2021,
													    "sourceType": "module"
															  },
																  "env": {
																	    "node": true,
																			    "es2021": true
																					  },
																						  "rules": {
																							    "simple-import-sort/imports": "error",
																									    "simple-import-sort/exports": "error"
																											  }
																										}
EOL

cat > .prettierrc.json <<EOL
{
	"semi": true,
	"singleQuote": true,
	"trailingComma": "all",
	"printWidth": 120,
	"tabWidth": 2
}
EOL

# Update package.json with scripts
npx json -I -f package.json -e 'this.scripts={ "dev": "nodemon --watch src --exec ts-node src/index.ts", "build": "tsc", "serve": "node dist/index.js", "lint": "eslint --ext .ts src/", "format": "prettier --write \"src/**/*.ts\"", "lint:fix": "eslint --ext .ts src/ --fix"}'

# Create directories and files
mkdir -p logs/ src/controllers src/models src/services src/routes

# Create index.ts with a sample code
cat > src/index.ts <<EOL
import dotenv from "dotenv";
import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import DailyRotateFile from "winston-daily-rotate-file";
import winston from "winston";
import sampleRoutes from './routes/sampleRoutes';

dotenv.config(); // Load environment variables

const port : string = process.env.PORT || "3000";

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(bodyParser.json());

// setup helmet
app.use(helmet());
app.use(helmet.hidePoweredBy());
app.use(helmet.frameguard({ action: 'deny' }));
app.use(helmet.xssFilter());
app.use(helmet.noSniff());
app.use(helmet.hsts({
  maxAge: 31536000,
	  includeSubDomains: true,
		  preload: true
		}));
		app.use(helmet.contentSecurityPolicy({
		  directives: {
			    defaultSrc: ["'self'"],
					    styleSrc: ["'self'", 'https://fonts.googleapis.com'],
							    fontSrc: ["'self'", 'https://fonts.gstatic.com']
									  }
								}));

// setup rate-limiting
const limiter = rateLimit({
	 windowMs: 1 * 60 * 1000, // 1 minute
	 max: 100, // 100 requests per minute
});
app.use(limiter);

// setup logger
const logger = winston.createLogger({
	level: "info",
	format: winston.format.combine(
		winston.format.timestamp({
			format: "YYYY-MM-DD HH:mm:ss",
		}),
		winston.format.errors({ stack: true }),
		winston.format.splat(),
		winston.format.json()
	),
	transports: [
		new DailyRotateFile({
			filename: "logs/application-%DATE%.log",
			datePattern: "YYYY-MM-DD",
			zippedArchive: true,
			maxSize: "20m",
			maxFiles: "14d",
		}),
	],
});

// log requests
app.use((req, res, next) => {
	logger.info({
		message: "Request URL",
		url: req.url,
		method: req.method,
		query: req.query,
		headers: req.headers,
		body: req.body,
	});
	next();
});

app.listen(port, () => {
   console.log(\`Server is running on port \${port}\`);
});
EOL


# Create a sample model
cat > src/models/sample.ts <<EOL
interface Sample {
  value: number;
  description: string;
  date: Date;
  category: string;
}

export { Sample };
EOL

# Create a sample service
cat > src/services/sampleService.ts <<EOL
import { Sample } from '../models/sample';

const getAllSamples = (): Promise<Sample[]> => {
	return new Promise<string>((resolve, reject) => {
		resolve("");
	});
};

const createSample = (sample: Sample): Promise<Sample> => {
	return new Promise<string>((resolve, reject) => {
		resolve("");
	});
};

const getSampleById = (id: string): Promise<Sample | null> => {
	return new Promise<string>((resolve, reject) => {
		resolve("");
	});
};

const updateSample = (id: string, sample: Sample): Promise<Sample | null> => {
	return new Promise<string>((resolve, reject) => {
		resolve("");
	});
};

const deleteSample = (id: string): Promise<Sample | null> => {
	return new Promise<string>((resolve, reject) => {
		resolve("");
	});
};

export { getAllSamples, createSample, getSampleById, updateSample, deleteSample };
EOL
	

# Create sample routes
cat > src/routes/sampleRoutes.ts <<EOL
import { Router } from 'express';
import * as SampleController from '../controllers/sampleController';

const router = Router();

router.get('/', SampleController.getAllSamples);
router.post('/', SampleController.createSample);
router.get('/:id', SampleController.getSampleById);
router.put('/:id', SampleController.updateSample);
router.delete('/:id', SampleController.deleteSample);

export default router;
EOL

# Create a sample controller
cat > src/controllers/sampleController.ts <<EOL
import { Request, Response } from 'express';
import * as SampleService from '../services/sampleService';

export const getAllSamples = async (req: Request, res: Response): Promise<void> => {
  try {
	    const samples = await SampleService.getAllSamples();
      res.status(200).json(samples);
	} catch (error: any) {
	    res.status(500).json({ error: error.message });
  }
};

export const createSample = async (req: Request, res: Response): Promise<void> => {
  try {
		const sample = await SampleService.createSample(req.body);
		res.status(201).json(sample);
	} catch (error: any) {
		res.status(500).json({ error: error.message });
	}
};

export const getSampleById = async (req: Request, res: Response): Promise<void> => {
	try {
		const sample = await SampleService.getSampleById(req.params.id);
		if (sample) {
			res.status(200).json(sample);
		} else {
			res.status(404).json({ error: 'Sample not found' });
		}
	} catch (error: any) {
			res.status(500).json({ error: error.message });
		}
	};

export const updateSample = async (req: Request, res: Response): Promise<void> => {
   try {
	    const sample = await SampleService.updateSample(req.params.id, req.body);
		if (sample) {
			res.status(200).json(sample);
		} else {
			res.status(404).json({ error: 'Sample not found' });
		}
	} catch (error: any) {
		res.status(500).json({ error: error.message });
	}
};

export const deleteSample = async (req: Request, res: Response): Promise<void> => {
	try {
		const sample = await SampleService.deleteSample(req.params.id);
		if (sample) {
			res.status(200).json
		}
		if (sample) {
			res.status(200).json(sample);
		} else {
			res.status(404).json({ error: 'Sample not found' });
		}
	} catch (error: any) {
		res.status(500).json({ error: error.message });
	}
};
EOL
