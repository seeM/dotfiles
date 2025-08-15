#!/usr/bin/env node
import net from 'net';
import crypto from 'crypto';
import path from 'path';
import os from 'os';

// Constants from deemon
const TALK = 1;

// Helper to get the IPC handle (same logic as deemon)
function getIPCHandle(command) {
	const scope = crypto
		.createHash('md5')
		.update(command.path)
		.update(command.args.toString())
		.update(command.cwd)
		.digest('hex');

	if (process.platform === 'win32') {
		return `\\\\.\\pipe\\daemon-${scope}`;
	} else {
		return path.join(
			process.env['XDG_RUNTIME_DIR'] || os.tmpdir(),
			`daemon-${scope}.sock`
		);
	}
}

// Function to tail deemon output
async function tailDeemon(command, lines = 50) {

	const handle = getIPCHandle(command);

	return new Promise((resolve, reject) => {
		const socket = net.createConnection(handle, () => {
			// Send TALK command to get output
			socket.write(new Uint8Array([TALK]));

			let output = '';
			let timeout;

			socket.on('data', (data) => {
				output += data.toString();

				// Reset timeout on each data chunk
				clearTimeout(timeout);
				timeout = setTimeout(() => {
					// After 200ms of no data, we've got the buffer, disconnect
					socket.end();
				}, 200);
			});

			socket.on('close', () => {
				clearTimeout(timeout);
				// Return last N lines
				const allLines = output.split('\n');
				const lastLines = allLines.slice(-lines).join('\n');
				resolve(lastLines);
			});
		});

		socket.on('error', (err) => {
			if (err.code === 'ECONNREFUSED' || err.code === 'ENOENT') {
				reject(new Error(`No daemon running for command: ${command.path} ${command.args.join(' ')}`));
			} else {
				reject(err);
			}
		});
	});
}

// Parse daemon specification: "label:path:arg1,arg2:cwd" or use defaults
function parseDaemonSpec(spec) {
	const parts = spec.split(':');
	if (parts.length === 1) {
		// Simple case: just script name, assume npm run
		return {
			label: parts[0].toUpperCase(),
			command: {
				path: 'npm',
				args: ['run', parts[0]],
				cwd: '/Users/seem/posit/positron'
			}
		};
	} else if (parts.length >= 3) {
		// Full specification
		const [label, path, argsStr, cwd = '/Users/seem/posit/positron'] = parts;
		const args = argsStr ? argsStr.split(',') : [];
		return {
			label: label || path.toUpperCase(),
			command: {
				path,
				args,
				cwd
			}
		};
	}
	console.error(`Invalid daemon specification: ${spec}`);
	process.exit(1);
}

// Main execution
async function main() {
	const args = process.argv.slice(2);
	
	// Parse arguments: either "lines daemon1 daemon2..." or just "daemon1 daemon2..."
	let lines = 50;
	let daemonSpecs = [];
	
	if (args.length === 0) {
		console.error('No daemons specified');
		process.exit(1);
	} else if (!isNaN(parseInt(args[0]))) {
		// First arg is lines count
		lines = parseInt(args[0]);
		daemonSpecs = args.slice(1);
		if (daemonSpecs.length === 0) {
			console.error('No daemons specified');
			process.exit(1);
		}
	} else {
		// All args are daemon specs
		daemonSpecs = args;
	}

	try {
		for (const spec of daemonSpecs) {
			const { label, command } = parseDaemonSpec(spec);
			console.log(`\n=== ${label} ===`);
			const output = await tailDeemon(command, lines);
			console.log(output);
		}
	} catch (err) {
		console.error(err.message);
		console.error('\nUsage:');
		console.error('  deemon-tail.js [lines] [daemon1] [daemon2] ...');
		console.error('  deemon-tail.js [daemon1] [daemon2] ...');
		console.error('\nDaemon formats:');
		console.error('  scriptname                    - npm run scriptname');
		console.error('  label:path:args:cwd          - custom command');
		process.exit(1);
	}
}

main();
