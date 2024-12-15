
const express = require('express');
const bodyParser = require('body-parser');
const winston = require('winston');
const { createLogger, format, transports } = winston;
const { combine, timestamp, json } = format;

const app = express();
const PORT = 3000;

app.use(bodyParser.json());

// Íàëàøòóâàííÿ Winston äëÿ Logstash
const logger = createLogger({
  format: combine(
    timestamp(),
    json()
  ),
  transports: [
    new transports.Console(), // Ëîãè âèâîäÿòüñÿ ó êîíñîëü
    new transports.Http({     // Ëîãè â³äïðàâëÿþòüñÿ â Logstash
      host: 'localhost',      // IP Minikube, ÿêùî âè ïðàöþºòå â Minikube
      port: 5000,             // Ïîðò, íà ÿêîìó ïðàöþº Logstash
    }),
    new transports.File({ filename: 'logs/app.log' }), // Ëîãè ëîêàëüíî ó ôàéë
  ],
});

// Middleware äëÿ ëîãóâàííÿ HTTP-çàïèò³â
app.use((req, res, next) => {
  logger.info({
    method: req.method,
    url: req.url,
    body: req.body,
    timestamp: new Date().toISOString(),
  });
  next();
});

// Ðåøòà âàøèõ åíäïî¿íò³â
let expenses = [];
let currentId = 1;

// POST /expenses
app.post('/expenses', (req, res) => {
  const { amount, category, description, date } = req.body;
  const newExpense = { id: currentId++, amount, category, description, date };
  expenses.push(newExpense);
  logger.info('New expense created', newExpense); // Ëîãóâàííÿ ó Winston
  res.status(201).json(newExpense);
});

// GET /healthcheck
app.get('/api/healthcheck', (req, res) => {
  res.send('ok');
});

// GET /expenses
app.get('/expenses', (req, res) => {
  logger.info('Fetching all expenses');
  res.json(expenses);
});

// GET /expenses/:id
app.get('/expenses/:id', (req, res) => {
  const expense = expenses.find(exp => exp.id === parseInt(req.params.id));
  if (expense) {
    logger.info(`Expense fetched: ${req.params.id}`, expense);
    res.json(expense);
  } else {
    logger.warn(`Expense not found: ${req.params.id}`);
    res.status(404).send('Expense not found');
  }
});

// PUT /expenses/:id
app.put('/expenses/:id', (req, res) => {
  const expense = expenses.find(exp => exp.id === parseInt(req.params.id));
  if (expense) {
    const { amount, category, description, date } = req.body;
    expense.amount = amount;
    expense.category = category;
    expense.description = description;
    expense.date = date;
    logger.info(`Expense updated: ${req.params.id}`, expense);
    res.json(expense);
  } else {
    logger.warn(`Expense not found: ${req.params.id}`);
    res.status(404).send('Expense not found');
  }
});

// DELETE /expenses/:id
app.delete('/expenses/:id', (req, res) => {
  const index = expenses.findIndex(exp => exp.id === parseInt(req.params.id));
  if (index !== -1) {
    const deletedExpense = expenses.splice(index, 1);
    logger.info(`Expense deleted: ${req.params.id}`, deletedExpense);
    res.json({ message: 'Expense deleted successfully' });
  } else {
    logger.warn(`Expense not found: ${req.params.id}`);
    res.status(404).send('Expense not found');
  }
});

app.listen(PORT, () => {
  logger.info(`Server is running on http://localhost:${PORT}`);
});
